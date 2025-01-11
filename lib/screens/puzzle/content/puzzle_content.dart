import 'dart:math';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
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
  final Map<String, dynamic> puzzleData;

  const PuzzleContent({
    super.key,
    required this.row,
    required this.column,
    required this.index,
    required this.puzzleHeight,
    required this.scaleFactor,
    required this.puzzleType,
    required this.puzzleData,
  });

  @override
  Widget build(BuildContext context) {
    final Color puzzleColor = puzzleData['color'];
    final rotationAngle = _getRotationAngle();
    final void Function() onTap;

    onTap = () {
      if (puzzleColor == Colors.white) {
        if (puzzleType == PuzzleType.personal) {
          BuildDialog.show(
            iconName: 'putWho',
            simpleDialog: true,
            context: context,
          );
        } else {
          PuzzleScreenHandler.navigateScreen(
            barrierColor: Colors.white70,
            child: PuzzleWritingScreen(puzzleType: puzzleType, reply: false),
            context: context,
          );
        }
      } else if (puzzleColor == Colors.white.withValues(alpha: 0.8)) {
        BuildDialog.show(
          iconName: 'subject',
          puzzleText: puzzleData['title'].replaceAll(r'\n', '\n'),
          puzzleColor: puzzleData['color'],
          context: context,
        );
      } else {
        BuildDialog.show(
          iconName: 'more',
          index: index,
          puzzleData: puzzleData,
          puzzleType: puzzleType,
          context: context,
        );
      }
    };

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
}
