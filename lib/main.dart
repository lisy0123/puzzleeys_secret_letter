import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/providers/color_picker_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_scale_provider.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_screen.dart';
import 'package:puzzleeys_secret_letter/screens/main_screen.dart';
import 'package:puzzleeys_secret_letter/styles/theme_setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['PROJECT_URL']!,
    anonKey: dotenv.env['API_KEY']!,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PuzzleScaleProvider()),
      ChangeNotifierProvider(create: (_) => WritingProvider()),
      ChangeNotifierProvider(create: (_) => ColorPickerProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: testing login (need to add apple login later)
    return ScreenUtilInit(
      designSize: const Size(2340, 1080),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeSetting.themeSetting(),
          home: const Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                MainScreen(),
                LoginScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}
