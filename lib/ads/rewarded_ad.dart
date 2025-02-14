import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'base_ad_manager.dart';

class RewardedInterstitialAdManager extends BaseAdManager<RewardedInterstitialAd> {
  @override
  void loadAd() {
    if (isLoading || isAdLoaded) return;
    isLoading = true;

    RewardedInterstitialAd.load(
      adUnitId: getAdUnitId(AdType.rewarded),
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: setAd,
        onAdFailedToLoad: (error) => onAdFailedToLoad(error.message),
      ),
    );
  }

  void _setCallbacks(RewardedInterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) => handleAdClosed(),
      onAdFailedToShowFullScreenContent: (_, error) {
        debugPrint("Rewarded Interstitial Ad failed: ${error.message}");
        handleAdClosed();
      },
    );
  }

  void _dispose(RewardedInterstitialAd? ad) {
    ad?.dispose();
  }

  void _show(RewardedInterstitialAd ad, VoidCallback? onRewardEarned) {
    ad.show(onUserEarnedReward: (_, __) => onRewardEarned?.call());
  }
}
