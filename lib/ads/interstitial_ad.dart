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
      adUnitId: getAdUnitId(AdType.interstitial),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: setAd,
        onAdFailedToLoad: (error) => onAdFailedToLoad(error.message),
      ),
    );
  }

  void _setCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) => handleAdClosed(),
      onAdFailedToShowFullScreenContent: (_, error) {
        debugPrint("Interstitial Ad failed: ${error.message}");
        handleAdClosed();
      },
    );
  }

  void _dispose(InterstitialAd? ad) {
    ad?.dispose();
  }

  void _show(InterstitialAd ad, VoidCallback? onRewardEarned) {
    ad.show();
  }
}
