import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AdType { interstitial, appOpen, rewarded }

class AdUtils {
  static String getAdUnitId(AdType adType) {
    final String appOpenAos = 'APP_OPEN_AD_ID_AOS';
    final String interstitialAos = 'INTERSTITIAL_AD_ID_AOS';
    final String rewardAos = 'REWARDED_AD_ID_AOS';

    final String appOpenIos = 'APP_OPEN_AD_ID_IOS';
    final String interstitialIos = 'INTERSTITIAL_AD_ID_IOS';
    final String rewardIos = 'REWARDED_AD_ID_IOS';

    // TODO: need to change before release
    if (Platform.isAndroid) {
      switch (adType) {
        case AdType.interstitial:
          return "ca-app-pub-3940256099942544/1033173712";
        // return dotenv.env[interstitialAos]!;
        case AdType.appOpen:
          return "ca-app-pub-3940256099942544/9257395921";
        // return dotenv.env[appOpenAos]!;
        case AdType.rewarded:
          return "ca-app-pub-3940256099942544/5354046379";
        // return dotenv.env[rewardAos]!;
      }
    } else if (Platform.isIOS) {
      switch (adType) {
        case AdType.interstitial:
          return "ca-app-pub-3940256099942544/4411468910";
        // return dotenv.env[interstitialIos]!;
        case AdType.appOpen:
          return "ca-app-pub-3940256099942544/5575463023";
        // return dotenv.env[appOpenIos]!;
        case AdType.rewarded:
          return "ca-app-pub-3940256099942544/6978759866";
        // return dotenv.env[rewardIos]!;
      }
    }
    return "";
  }
}
