import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/ads/ad_utils.dart';
import 'package:puzzleeys_secret_letter/ads/base_ad_manager.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();

  factory AdManager() => _instance;

  AdManager._internal();

  late Map<AdType, BaseAdManager> _adManagers;
  int _postViewCount = 0;

  Future<void> initialize({
    required BaseAdManager interstitialAd,
    required BaseAdManager rewardedAd,
    required BaseAdManager nativeAd,
  }) async {
    _adManagers = {
      AdType.interstitial: interstitialAd,
      AdType.rewarded: rewardedAd,
      AdType.native: nativeAd,
    };

    final String? value = await SharedPreferencesUtils.get("postViewCount");
    _postViewCount = value != null ? int.parse(value) : 0;

    final List<AdType> adTypes = _adManagers.keys.toList();
    for (var adType in adTypes) {
      _adManagers[adType]?.loadAd();
    }
  }

  Future<void> showInterstitialAd() => _showAd(AdType.interstitial);

  Future<void> showRewardedAd(VoidCallback onRewardEarned) =>
      _showAd(AdType.rewarded, onRewardEarned);

  void showNativeAd() => _showAd(AdType.rewarded);

  Future<void> _showAd(AdType adType, [VoidCallback? onRewardEarned]) async {
    if (adType == AdType.interstitial) {
      _postViewCount++;
      await SharedPreferencesUtils.save("postViewCount", '$_postViewCount');
    }

    if (!_canShowAd(adType)) return;

    switch (adType) {
      case AdType.interstitial:
        _postViewCount = 0;
        break;
      case AdType.rewarded:
        if (_postViewCount == 7) {
          _postViewCount -= 3;
        }
        break;
      default:
        break;
    }

    if (adType != AdType.native) {
      await SharedPreferencesUtils.save("postViewCount", '$_postViewCount');
    }

    final ad = _adManagers[adType];
    if (ad == null || !ad.isAdLoaded) {
      ad?.loadAd();
    }

    if (adType == AdType.rewarded) {
      ad?.showAd(onRewardEarned);
    } else {
      ad?.showAd();
    }
  }

  bool _canShowAd(AdType adType) {
    switch (adType) {
      case AdType.rewarded:
        return true;
      case AdType.interstitial:
        return _postViewCount == 7;
      default:
        return true;
    }
  }
}
