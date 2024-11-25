import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/home/home_button.dart';
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
      width: MediaQuery.of(context).size.width,
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
        const HomeButton(iconName: 'setting'),
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
          onTap: () => HomeButton().onTap(context),
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
        SvgPicture.asset(
          'assets/imgs/bar_puzzle.svg',
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
}
