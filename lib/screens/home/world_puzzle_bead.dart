import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class WorldPuzzleBead extends StatelessWidget {
  const WorldPuzzleBead({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> worldFinalGradientColors = [
      VarSetting.worldGradientColors[1],
      VarSetting.worldGradientColors[0],
      VarSetting.worldGradientColors[2],
    ];

    return Center(
      child: _buildWorldPuzzleBead(
        gradientColors: worldFinalGradientColors,
        context: context,
      ),
    );
  }

  Widget _buildWorldPuzzleBead({
    required List<Color> gradientColors,
    required BuildContext context,
  }) {
    final double beadSize = MediaQuery.of(context).size.width - 56.0;

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        top: 40.0,
      ),
      width: beadSize,
      height: beadSize,
      decoration: BoxDecorationSetting.boxDecorationPuzzleBead(
        gradientColors: gradientColors,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => onTapWorldPuzzleBead(context),
        icon: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/imgs/puzzle_pattern.png',
              fit: BoxFit.contain,
            ),
            TextSetting.textWorldPuzzle(
              worldPuzzleNums: VarSetting.worldPuzzleNums,
              myPuzzleNums: VarSetting.myPuzzleNums,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  void onTapWorldPuzzleBead(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PuzzleScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }
}
