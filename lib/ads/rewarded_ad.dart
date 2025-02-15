import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'base_ad_manager.dart';

class RewardedInterstitialAdManager
    extends BaseAdManager<RewardedInterstitialAd> {
  @override
  void loadAd() {
    if (isLoading || isAdLoaded) return;
    isLoading = true;

    RewardedInterstitialAd.load(
      adUnitId: AdUtils.getAdUnitId(AdType.rewarded),
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: setAd,
        onAdFailedToLoad: (error) => onAdFailedToLoad(error.message),
      ),
    );
  }

  void setCallbacks(RewardedInterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) => handleAdClosed(),
      onAdFailedToShowFullScreenContent: (_, error) {
        debugPrint("Rewarded interstitial ad failed: ${error.message}");
        handleAdClosed();
      },
    );
  }

  void dispose(RewardedInterstitialAd? ad) {
    ad?.dispose();
  }

  void show(RewardedInterstitialAd ad, VoidCallback? onRewardEarned) {
    ad.show(onUserEarnedReward: (_, __) => onRewardEarned?.call());
  }
}
