import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/screens/home/home_icons.dart';
import 'package:puzzleeys_secret_letter/screens/home/world_puzzle_bead.dart';
import 'package:puzzleeys_secret_letter/screens/home/home_status_bar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: ColorSetting.colorBase,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            HomeStatusBar(),
            WorldPuzzleBead(),
            HomeIcons(),
          ],
        ),
      ),
    );
  }
}