import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:puzzleeys_secret_letter/ads/base_ad_manager.dart';

class NativeAdManager extends BaseAdManager<NativeAd> {
  late NativeAd _nativeAd;

  @override
  void loadAd() {
    if (isLoading || isAdLoaded) return;
    isLoading = true;

    _nativeAd = NativeAd(
      adUnitId: AdUtils.getAdUnitId(AdType.native),
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _nativeAd = ad as NativeAd;
          setAd(ad);
        },
        onAdFailedToLoad: (_, error) {
          onAdFailedToLoad(error.message);
          handleAdClosed();
        },
      ),
    );
    _nativeAd.load();
  }

  @override
  void dispose(NativeAd? ad) {
    ad?.dispose();
  }

  @override
  void setCallbacks(NativeAd ad) {}

  @override
  void show(NativeAd ad, VoidCallback? onRewardEarned) {}
}
