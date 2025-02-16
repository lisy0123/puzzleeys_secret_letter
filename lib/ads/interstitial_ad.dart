import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'package:puzzleeys_secret_letter/ads/base_ad_manager.dart';

class InterstitialAdManager extends BaseAdManager<InterstitialAd> {
  @override
  void loadAd() {
    if (isLoading || isAdLoaded) return;
    isLoading = true;

    InterstitialAd.load(
      adUnitId: AdUtils.getAdUnitId(AdType.interstitial),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: setAd,
        onAdFailedToLoad: (error) => onAdFailedToLoad(error.message),
      ),
    );
  }

  @override
  void setCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) => handleAdClosed(),
      onAdFailedToShowFullScreenContent: (_, error) {
        debugPrint("Interstitial ad failed: ${error.message}");
        handleAdClosed();
      },
    );
  }

  @override
  void dispose(InterstitialAd? ad) {
    ad?.dispose();
  }

  @override
  void show(InterstitialAd ad, VoidCallback? onRewardEarned) {
    ad.show();
  }
}
