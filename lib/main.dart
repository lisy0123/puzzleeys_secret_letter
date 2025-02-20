import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' show MobileAds;
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/ads/ad_manager.dart';
import 'package:puzzleeys_secret_letter/ads/interstitial_ad.dart';
import 'package:puzzleeys_secret_letter/ads/native_ad.dart';
import 'package:puzzleeys_secret_letter/ads/rewarded_ad.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_screen_provider.dart';
import 'package:puzzleeys_secret_letter/providers/bar_provider.dart';
import 'package:puzzleeys_secret_letter/providers/delete_dialog_provider.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/providers/color_picker_provider.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_offset_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_scale_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/read_puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/login/auth_check_screen.dart';
import 'package:puzzleeys_secret_letter/styles/theme_setting.dart';
import 'package:puzzleeys_secret_letter/utils/push_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");

  await Future.wait([
    Supabase.initialize(
      url: dotenv.env['PROJECT_URL']!,
      anonKey: dotenv.env['API_KEY']!,
    ),
    AdManager().initialize(
      interstitialAd: InterstitialAdManager(),
      rewardedAd: RewardedAdManager(),
      nativeAd: NativeAdManager(),
    ),
    // PushNotification().initialize(),
  ]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FlutterNativeSplash.remove();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PuzzleScaleProvider()),
      ChangeNotifierProvider(create: (_) => PuzzleOffsetProvider()),
      ChangeNotifierProvider(create: (_) => ColorPickerProvider()),
      ChangeNotifierProvider(create: (_) => AuthStatusProvider()),
      ChangeNotifierProvider(create: (_) => PuzzleProvider()),
      ChangeNotifierProvider(create: (_) => FcmTokenProvider()),
      ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
      ChangeNotifierProvider(create: (_) => ReadPuzzleProvider()),
      ChangeNotifierProvider(create: (_) => PuzzleScreenProvider()),
      ChangeNotifierProvider(create: (_) => BeadProvider()),
      ChangeNotifierProvider(create: (_) => BarProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context).copyWith(boldText: false);

    return ScreenUtilInit(
      designSize: const Size(2340, 1080),
      builder: (context, child) {
        return MediaQuery(
          data: mediaQueryData,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ko')],
            theme: ThemeSetting.themeSetting(),
            home: AuthCheckScreen(),
          ),
        );
      },
    );
  }
}
