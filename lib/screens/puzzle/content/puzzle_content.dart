import 'dart:math';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/board_puzzle.dart';

class PuzzleContent extends StatelessWidget {
  final int row;
  final int column;
  final int index;
  final double puzzleHeight;
  final double scaleFactor;
  final PuzzleType puzzleType;
  final Color puzzleColor;

  const PuzzleContent({
    super.key,
    required this.row,
    required this.column,
    required this.index,
    required this.puzzleHeight,
    required this.scaleFactor,
    required this.puzzleType,
    required this.puzzleColor,
  });

  @override
  Widget build(BuildContext context) {
    final rotationAngle = _getRotationAngle();
    final void Function() onTap;
    if (puzzleColor == Colors.white) {
      if (puzzleType == PuzzleType.personal) {
        onTap = () {
          BuildDialog.show(
            iconName: 'putWho',
            simpleDialog: true,
            context: context,
          );
        };
      } else {
        onTap = () {
          PuzzleScreenHandler.navigateScreen(
            barrierColor: Colors.white70,
            child: PuzzleWritingScreen(puzzleType: puzzleType, reply: false),
            context: context,
          );
        };
      }
    } else {
      onTap = () => _showPuzzleDialog(puzzleColor, context);
    }

    return LayoutId(
      id: index,
      child: GestureDetector(
        onTap: onTap,
        child: RepaintBoundary(
          child: Transform.rotate(
            angle: rotationAngle,
            child: CustomPaint(
              size: Size(puzzleHeight, puzzleHeight),
              painter: BoardPuzzle(
                puzzleColor: puzzleColor,
                scaleFactor: scaleFactor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getRotationAngle() {
    return (row % 2 == column % 2) ? pi / 2 : pi;
  }

  void _showPuzzleDialog(Color puzzleColor, BuildContext context) {
    PuzzleScreenHandler.navigateScreen(
      barrierColor: puzzleColor.withValues(alpha: 0.8),
      child: PuzzleDetailScreen(
        index: index,
        puzzleColor: puzzleColor,
        puzzleType: puzzleType,
      ),
      context: context,
    );
  }
}
