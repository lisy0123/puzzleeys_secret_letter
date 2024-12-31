import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'package:puzzleeys_secret_letter/widgets/board_puzzle.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class PuzzleContent extends StatelessWidget {
  final int row;
  final int column;
  final int index;
  final double puzzleHeight;
  final double scaleFactor;
  final String puzzleState;
  final Color puzzleColor;

  const PuzzleContent({
    super.key,
    required this.row,
    required this.column,
    required this.index,
    required this.puzzleHeight,
    required this.scaleFactor,
    required this.puzzleState,
    required this.puzzleColor,
  });

  @override
  Widget build(BuildContext context) {
    final rotationAngle = _getRotationAngle();

    return LayoutId(
      id: index,
      child: GestureDetector(
        onTap: () => _showPuzzleDialog(puzzleColor, context),
        child: RepaintBoundary(
          child: ValueListenableBuilder<double>(
            valueListenable: ValueNotifier(scaleFactor),
            builder: (context, scale, child) {
              return Transform.rotate(
                angle: rotationAngle,
                child: CustomPaint(
                  size: Size(
                    puzzleHeight * scale,
                    puzzleHeight * scale,
                  ),
                  painter: BoardPuzzle(puzzleColor: puzzleColor),
                ),
              );
              // child: SvgPicture.asset(
              //   'assets/imgs/board_puzzle.svg',
              //   height: puzzleHeight * scaleFactor,
              //   fit: BoxFit.contain,
              //   colorFilter: ColorFilter.mode(
              //     puzzleColor.withValues(alpha: 0.8),
              //     BlendMode.srcATop,
              //   ),
            },
          ),
        ),
      ),
    );
  }

  double _getRotationAngle() {
    return (row % 2 == column % 2) ? pi / 2 : pi;
  }

  void _showPuzzleDialog(Color puzzleColor, BuildContext context) {
    final Color puzzleLightColor = ColorMatch(puzzleColor)();

    PuzzleScreenHandler.navigateScreen(
      barrierColor: puzzleColor.withValues(alpha: 0.7),
      child: PuzzleDetailScreen(
        index: index,
        puzzleColor: puzzleLightColor,
        puzzleState: puzzleState,
      ),
      context: context,
    );
  }
}
