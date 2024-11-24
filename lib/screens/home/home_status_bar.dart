import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class HomeStatusBar extends StatelessWidget {
  const HomeStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainBarBox(context),
        _buildMainBar(
          myGradientColors: VarSetting.myGradientColors,
          context: context,
        ),
      ],
    );
  }

  Widget _buildMainBarBox(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 32.0,
      margin: const EdgeInsets.only(
        left: 50.0,
        right: 16.0,
        top: 12.0,
      ),
      decoration: BoxDecorationSetting.boxDecorationShadowBorder(),
    );
  }

  Widget _buildMainBar({
    required List<Color> myGradientColors,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildMainBarLeft(
          myGradientColors: myGradientColors,
          context: context,
        ),
        _buildSettingButton(context),
      ],
    );
  }

  Widget _buildMainBarLeft({
    required List<Color> myGradientColors,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTapMyPuzzleBead(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16.0),
            width: 56.0,
            height: 56.0,
            decoration: BoxDecorationSetting.boxDecorationPuzzleBead(
              gradientColors: myGradientColors,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Image.asset(
          'assets/imgs/bar_puzzle.png',
          height: 22.0,
        ),
        const SizedBox(width: 8.0),
        TextSetting.textPuzzleNums(
          puzzleNums: VarSetting.puzzleNums,
          context: context,
        ),
      ],
    );
  }

  Widget _buildSettingButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapSetting(context),
      child: Container(
        margin: const EdgeInsets.only(right: 32.0),
        height: 20.0,
        child: Image.asset('assets/imgs/icon_setting.png'),
      ),
    );
  }

  void onTapMyPuzzleBead(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("My puzzle bead"),
        );
      },
    );
  }

  void onTapSetting(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Setting"),
        );
      },
    );
  }
}
