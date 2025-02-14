import 'dart:io' show Platform;

enum AdType { interstitial, appOpen, rewarded }

String getAdUnitId(AdType adType) {
  if (Platform.isAndroid) {
    switch (adType) {
      case AdType.interstitial:
        return "ca-app-pub-3940256099942544/1033173712";
      case AdType.appOpen:
        return "ca-app-pub-3940256099942544/9257395921";
      case AdType.rewarded:
        return "ca-app-pub-3940256099942544/5354046379";
    }
  } else if (Platform.isIOS) {
    switch (adType) {
      case AdType.interstitial:
        return "ca-app-pub-3940256099942544/4411468910";
      case AdType.appOpen:
        return "ca-app-pub-3940256099942544/5575463023";
      case AdType.rewarded:
        return "ca-app-pub-3940256099942544/6978759866";
    }
  }
  return "";
}
