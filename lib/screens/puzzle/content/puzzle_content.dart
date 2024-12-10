import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'dart:math' as math;

class PuzzleContent extends StatelessWidget {
  final int row;
  final int column;
  final int index;
  final double puzzleHeight;
  final double scaleFactor;
  final String puzzleState;

  const PuzzleContent({
    super.key,
    required this.row,
    required this.column,
    required this.index,
    required this.puzzleHeight,
    required this.scaleFactor,
    required this.puzzleState,
  });

  @override
  Widget build(BuildContext context) {
    final puzzleColor = ColorSetting.colorRed;
    final puzzleLightColor = ColorMatch(puzzleColor)();
    final rotationAngle = _getRotationAngle();

    return LayoutId(
      id: index,
      child: GestureDetector(
        onTap: () => _showPuzzleDialog(puzzleLightColor, context),
        child: Transform.rotate(
          angle: rotationAngle,
          child: SvgPicture.asset(
            'assets/imgs/board_puzzle.svg',
            height: puzzleHeight * scaleFactor,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              puzzleColor.withOpacity(0.8),
              BlendMode.srcATop,
            ),
          ),
        ),
      ),
    );
  }

  double _getRotationAngle() {
    return (row % 2 == column % 2) ? 90 * math.pi / 180 : 90 * math.pi / 90;
  }

  void _showPuzzleDialog(Color puzzleLightColor, BuildContext context) {
    PuzzleScreenHandler.navigateScreen(
      barrierColor: puzzleLightColor.withOpacity(0.8),
      child: PuzzleDetailScreen(
        index: index,
        puzzleColor: puzzleLightColor,
        puzzleState: puzzleState,
      ),
      context: context,
    );
  }
}
