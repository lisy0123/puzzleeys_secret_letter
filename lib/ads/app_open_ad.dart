import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'package:puzzleeys_secret_letter/ads/base_ad_manager.dart';

class AppOpenAdManager extends BaseAdManager<AppOpenAd> {
  @override
  void loadAd() {
    if (isLoading || isAdLoaded) return;
    isLoading = true;

    AppOpenAd.load(
      adUnitId: AdUtils.getAdUnitId(AdType.appOpen),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: setAd,
        onAdFailedToLoad: (error) => onAdFailedToLoad(error.message),
      ),
    );
  }

  void setCallbacks(AppOpenAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) => handleAdClosed(),
      onAdFailedToShowFullScreenContent: (_, error) {
        debugPrint("App Open Ad failed: ${error.message}");
        handleAdClosed();
      },
    );
  }

  void dispose(AppOpenAd? ad) {
    ad?.dispose();
  }

  void show(AppOpenAd ad, VoidCallback? onRewardEarned) {
    ad.show();
  }
}
