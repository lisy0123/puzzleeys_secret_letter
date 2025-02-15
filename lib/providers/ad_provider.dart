import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class AdProvider with ChangeNotifier {
  int _appLaunchCount = 0;
  int _postViewCount = 0;
  int _postGap = 0;
  String _lastAdShowDate = '';
  String? _playedRewardedAd;

  int get appLaunchCount => _appLaunchCount;
  int get postViewCount => _postViewCount;
  int get postGap => _postGap;
  String get lastAdShowDate => _lastAdShowDate;
  String? get playedRewardedAd => _playedRewardedAd;

  void initialize() async {
    final int appLaunchCount = await _getIntPreference("appLaunchCount");
    final int postViewCount = await _getIntPreference("postViewCount");
    final int postGap = await _getIntPreference("postGap");
    final String lastAdShowDate =
        await SharedPreferencesUtils.get("lastAdShowDate") ?? '';
    final String? playedRewardedAd =
        await SharedPreferencesUtils.get("playedRewardedAd");

    _appLaunchCount = appLaunchCount;
    _postViewCount = postViewCount;
    _postGap = postGap;
    _lastAdShowDate = lastAdShowDate;
    _playedRewardedAd = playedRewardedAd;

    notifyListeners();
  }

  Future<int> _getIntPreference(String key) async {
    final String? value = await SharedPreferencesUtils.get(key);
    return value != null ? int.parse(value) : 0;
  }
}
