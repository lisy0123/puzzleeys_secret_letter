import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'package:puzzleeys_secret_letter/ads/base_ad_manager.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class AdManager {
  final Map<AdType, BaseAdManager> _adManagers;

  AdManager({
    required BaseAdManager interstitialAd,
    required BaseAdManager appOpenAd,
    required BaseAdManager rewardedAd,
  }) : _adManagers = {
          AdType.interstitial: interstitialAd,
          AdType.appOpen: appOpenAd,
          AdType.rewarded: rewardedAd,
        };

  Future<void> loadAds() async {
    final int count =
        await AdConditionManager.getIntPreference("appLaunchCount");

    if (count < 7) {
      await SharedPreferencesUtils.save("appLaunchCount", '${count + 1}');
    }

    final adTypes = _adManagers.keys.toList();
    final canShowAds =
        await Future.wait(adTypes.map((adType) => _canShowAd(adType)));

    for (int i = 0; i < adTypes.length; i++) {
      if (canShowAds[i]) {
        _adManagers[adTypes[i]]?.loadAd();
      }
    }
  }

  Future<bool> _canShowAd(AdType adType) async {
    switch (adType) {
      case AdType.rewarded:
        return true;
      case AdType.interstitial:
        return await AdConditionManager.canShowInterstitialAd();
      case AdType.appOpen:
        return await AdConditionManager.canShowAppOpenAd();
    }
  }

  Future<void> showAppOpenAd() async {
    final bool checkCount = await AdConditionManager.canShowAppOpenAd();

    if (checkCount) {
      await _incrementAdCount(AdType.appOpen);

      final ad = _adManagers[AdType.appOpen];
      if (ad?.isAdLoaded == true) {
        ad?.showAd();
      } else {
        ad?.loadAd();
      }
    }
  }

  void showInterstitialAd() => _showAd(AdType.interstitial);

  void showRewardedAd(VoidCallback onRewardEarned) =>
      _showAd(AdType.rewarded, onRewardEarned);

  Future<void> _showAd(AdType adType, [VoidCallback? onRewardEarned]) async {
    await _resetCountsIfNewDay();

    if (!await _canShowAd(adType)) return;

    final ad = _adManagers[adType];
    if (ad == null || !ad.isAdLoaded) {
      ad?.loadAd();
      return;
    }

    final Map<String, int> preferences =
        await AdConditionManager.getAdPreferences();
    final int postViewCount = preferences["postViewCount"]!;
    final int postGap = preferences["postGap"]!;

    final bool canShowInterstitialAd =
        (postViewCount == 10) && (postGap > 2 || postGap == 0);

    if (adType == AdType.rewarded && canShowInterstitialAd) {
      final int newCount =
          postViewCount == 10 ? postViewCount - 2 : postViewCount;

      if (postViewCount != newCount) {
        await SharedPreferencesUtils.save("postViewCount", '$newCount');
      }
      await SharedPreferencesUtils.save("playedRewardedAd", "Y");
      await SharedPreferencesUtils.save("postGap", "0");
    }

    await _incrementAdCount(adType);

    if (adType == AdType.rewarded) {
      ad.showAd(onRewardEarned);
    } else {
      ad.showAd();
    }
  }

  Future<void> _resetCountsIfNewDay() async {
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);
    final lastAdShowDate = await SharedPreferencesUtils.get("lastAdShowDate");

    if (lastAdShowDate != currentDate) {
      await SharedPreferencesUtils.save("lastAdShowDate", currentDate);
      await SharedPreferencesUtils.save("appLaunchCount", "0");
    }
  }

  Future<void> _incrementAdCount(AdType adType) async {
    if (adType == AdType.rewarded) return;

    final date = DateTime.now().toIso8601String().substring(0, 10);
    await SharedPreferencesUtils.save("${adType}lastAdShowDate", date);

    final int postViewCount =
        await AdConditionManager.getIntPreference("postViewCount");
    await SharedPreferencesUtils.save("postViewCount", '${postViewCount + 1}');

    final String? playedRewardedAd =
        await SharedPreferencesUtils.get("playedRewardedAd");

    if (playedRewardedAd != null) {
      final int gapCount = await AdConditionManager.getIntPreference("postGap");
      await SharedPreferencesUtils.save("postGap", '${gapCount + 1}');
    }
  }
}

class AdConditionManager {
  static Future<bool> canShowInterstitialAd() async {
    final Map<String, int> preferences = await getAdPreferences();
    return (preferences["postViewCount"]! == 10) &&
        (preferences["postViewCount"]! > 2 || preferences["postGap"]! == 0);
  }

  static Future<bool> canShowAppOpenAd() async {
    final int count = await getIntPreference("appLaunchCount");
    return count == 2 || count == 5;
  }

  static Future<Map<String, int>> getAdPreferences() async {
    final int postViewCount = await getIntPreference("postViewCount");
    final int postGap = await getIntPreference("postGap");
    return {"postViewCount": postViewCount, "postGap": postGap};
  }

  static Future<int> getIntPreference(String key) async {
    final String? value = await SharedPreferencesUtils.get(key);
    return value != null ? int.parse(value) : 0;
  }
}
