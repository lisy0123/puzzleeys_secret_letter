import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/providers/check_screen_provider.dart';
import 'package:puzzleeys_secret_letter/providers/delete_dialog_provider.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/providers/color_picker_provider.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_personal_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_scale_provider.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/screens/login/auth_check_screen.dart';
import 'package:puzzleeys_secret_letter/styles/theme_setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await dotenv.load(fileName: ".env");
  await Future.wait([
    Supabase.initialize(
      url: dotenv.env['PROJECT_URL']!,
      anonKey: dotenv.env['API_KEY']!,
    ),
    Firebase.initializeApp(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);
  FlutterNativeSplash.remove();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PuzzleScaleProvider()),
      ChangeNotifierProvider(create: (_) => WritingProvider()),
      ChangeNotifierProvider(create: (_) => ColorPickerProvider()),
      ChangeNotifierProvider(create: (_) => AuthStatusProvider()),
      ChangeNotifierProvider(create: (_) => PuzzleProvider()),
      ChangeNotifierProvider(create: (_) => FcmTokenProvider()),
      ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
      ChangeNotifierProvider(create: (_) => PuzzlePersonalProvider()),
      ChangeNotifierProvider(create: (_) => CheckScreenProvider()),
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
            home: Scaffold(
              resizeToAvoidBottomInset: false,
              body: AuthCheckScreen(),
            ),
          ),
        );
      },
    );
  }
}
