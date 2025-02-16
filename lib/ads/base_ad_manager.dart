import 'dart:async';
import 'package:flutter/widgets.dart';

abstract class BaseAdManager<T> {
  T? _ad;
  bool _isAdLoaded = false;
  bool isLoading = false;
  int _retryCount = 0;
  static const int _maxRetryCount = 3;

  bool get isAdLoaded => _isAdLoaded;

  void loadAd();

  void retryLoad() {
    if (_retryCount < _maxRetryCount) {
      int delay = 500 * (1 << _retryCount++);
      Future.delayed(Duration(milliseconds: delay), loadAd);
    }
  }

  void showAd([VoidCallback? onRewardEarned]) {
    if (_ad == null || !_isAdLoaded) return;
    show(_ad as T, onRewardEarned);
    disposeAd();
  }

  void disposeAd() {
    dispose(_ad);
    _ad = null;
    _isAdLoaded = false;
    isLoading = false;
  }

  void handleAdClosed() {
    disposeAd();
    loadAd();
  }

  void setAd(T ad) {
    disposeAd();
    _ad = ad;
    _isAdLoaded = true;
    _retryCount = 0;
    isLoading = false;
    setCallbacks(ad);
  }

  void onAdFailedToLoad(String errorMessage) {
    debugPrint("Ad failed: $errorMessage");
    _isAdLoaded = false;
    isLoading = false;
    retryLoad();
  }

  void setCallbacks(T ad);

  void dispose(T? ad);

  void show(T ad, VoidCallback? onRewardEarned);
}
