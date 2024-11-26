import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/screens/home/world_puzzle_bead.dart';
import 'package:puzzleeys_secret_letter/screens/home/home_status_bar.dart';
import 'package:puzzleeys_secret_letter/widgets/home_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSetting.colorBase,
      body: Stack(
        children: [
          WorldPuzzleBead(),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 8.0),
                HomeStatusBar(),
                _buildIcons(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIcons(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(top: 4.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(4, (index) {
            return Column(
              children: [
                HomeButton(iconName: index.toString()),
                const SizedBox(height: 18.0),
              ],
            );
          }),
        ],
      ),
    );
  }
}
