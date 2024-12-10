import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_scale_provider.dart';
import 'package:puzzleeys_secret_letter/styles/theme_setting.dart';
import 'package:puzzleeys_secret_letter/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PuzzleScaleProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(2340, 1080),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeSetting.themeSetting(),
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: MainScreen(),
          ),
        );
      },
    );
  }
}
