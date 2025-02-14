import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'package:puzzleeys_secret_letter/ads/base_ad_manager.dart';
import 'package:puzzleeys_secret_letter/ads/rewarded_ad.dart';

class AdManager {
  final Map<AdType, AdManagerBase> _ads;

  AdManager({
    required AdManagerBase interstitialAd,
    required AdManagerBase appOpenAd,
    required AdManagerBase rewardedAd,
  }) : _ads = {
          AdType.interstitial: interstitialAd,
          AdType.appOpen: appOpenAd,
          AdType.rewarded: rewardedAd,
        };

  void loadAllAds() {
    for (var ad in _ads.values) {
      ad.loadAd();
    }
  }

  void tryShowAd(AdType adType, [VoidCallback? onRewardEarned]) {
    final ad = _ads[adType];

    if (ad == null) {
      debugPrint("AdManager: $adType ad is not configured.");
      return;
    }

    if (ad.isAdLoaded) {
      if (adType == AdType.rewarded &&
          ad is RewardedInterstitialAdManager &&
          onRewardEarned != null) {
        ad.showAd(onRewardEarned);
      } else {
        ad.showAd();
      }
    } else {
      debugPrint("AdManager: ${adType.name} ad not loaded yet. Reloading...");
      ad.loadAd();
    }
  }

  void showInterstitialAd() => tryShowAd(AdType.interstitial);

  void showAppOpenAd() => tryShowAd(AdType.appOpen);

  void showRewardedAd(VoidCallback onRewardEarned) =>
      tryShowAd(AdType.rewarded, onRewardEarned);
}
