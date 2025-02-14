import 'dart:async';
import 'package:flutter/widgets.dart';

abstract class AdManagerBase {
  bool get isAdLoaded;
  void loadAd();
  void showAd([VoidCallback? onRewardEarned]);
}

abstract class BaseAdManager<T> implements AdManagerBase {
  T? _ad;
  bool _isAdLoaded = false;
  bool isLoading = false;
  int _retryCount = 0;
  static const int _maxRetryCount = 3;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void loadAd();

  void retryLoad() {
    if (_retryCount < _maxRetryCount) {
      int delay = 500 * (1 << _retryCount++);
      Future.delayed(Duration(milliseconds: delay), loadAd);
    } else {
      debugPrint("Max retries reached. No more attempts.");
    }
  }

  @override
  void showAd([VoidCallback? onRewardEarned]) {
    if (_ad == null || !_isAdLoaded) return;
    _show(_ad as T, onRewardEarned);
    disposeAd();
  }

  void disposeAd() {
    _dispose(_ad);
    _ad = null;
    _isAdLoaded = false;
    isLoading = false;
  }

  void handleAdClosed() {
    debugPrint("Ad dismissed. Loading new ad...");
    disposeAd();
    loadAd();
  }

  void setAd(T ad) {
    disposeAd();
    _ad = ad;
    _isAdLoaded = true;
    _retryCount = 0;
    isLoading = false;
    _setCallbacks(ad);
  }

  void onAdFailedToLoad(String errorMessage) {
    debugPrint("Ad failed: $errorMessage");
    _isAdLoaded = false;
    isLoading = false;
    retryLoad();
  }

  void _setCallbacks(T ad);
  void _dispose(T? ad);
  void _show(T ad, VoidCallback? onRewardEarned);
}