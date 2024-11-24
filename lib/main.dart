import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/theme_setting.dart';
import 'package:puzzleeys_secret_letter/screens/home/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {

   return MaterialApp(
     theme: ThemeSetting.themeSetting(),
     home: HomeScreen(),
     );
 }
}
