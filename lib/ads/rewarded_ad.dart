import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'package:puzzleeys_secret_letter/ads/base_ad_manager.dart';

class RewardedAdManager extends BaseAdManager<RewardedAd> {
  VoidCallback? onRewardEarned;

  @override
  void loadAd() {
    if (isLoading || isAdLoaded) return;
    isLoading = true;

    RewardedAd.load(
      adUnitId: AdUtils.getAdUnitId(AdType.rewarded),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: setAd,
        onAdFailedToLoad: (error) => onAdFailedToLoad(error.message),
      ),
    );
  }

  @override
  void setCallbacks(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        onRewardEarned?.call();
        handleAdClosed();
      },
      onAdFailedToShowFullScreenContent: (_, error) {
        debugPrint("Rewarded ad failed: ${error.message}");
        handleAdClosed();
      },
    );
  }

  @override
  void dispose(RewardedAd? ad) {
    ad?.dispose();
  }

  @override
  void show(RewardedAd ad, VoidCallback? onRewardEarned) {
    this.onRewardEarned = onRewardEarned;
    ad.show(onUserEarnedReward: (_, __) {});
  }
}
