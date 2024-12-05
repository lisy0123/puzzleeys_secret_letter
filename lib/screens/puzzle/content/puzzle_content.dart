import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/writing/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/color_match.dart';

class PuzzleContent extends StatefulWidget {
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
  State<PuzzleContent> createState() => _PuzzleContentState();
}

class _PuzzleContentState extends State<PuzzleContent> {
  double startDragY = 0;

  @override
  Widget build(BuildContext context) {
    final rotateAngle = _calculateRotationAngle();
    final puzzleColor = ColorSetting.colorBlue;

    return LayoutId(
      id: widget.index,
      child: GestureDetector(
        onTap: () => _showPuzzleDialog(puzzleColor),
        child: Transform.rotate(
          angle: rotateAngle,
          child: SvgPicture.asset(
            'assets/imgs/board_puzzle.svg',
            height: widget.puzzleHeight * widget.scaleFactor,
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

  double _calculateRotationAngle() {
    return (widget.row % 2 == widget.column % 2)
        ? 90 * math.pi / 180
        : 90 * math.pi / 90;
  }

  void _showPuzzleDialog(Color puzzleColor) {
    showDialog(
      barrierDismissible: false,
      barrierColor: ColorMatch(baseColor: puzzleColor)().withOpacity(0.8),
      context: context,
      builder: (_) => _buildPuzzleDialogContent(),
    );
  }

  Widget _buildPuzzleDialogContent() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      child: PuzzleDetailScreen(
        index: widget.index,
        puzzleState: widget.puzzleState,
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    double dragDistance = details.globalPosition.dy - startDragY;

    if (dragDistance > 10) Navigator.pop(context);
    if (dragDistance < -10) PuzzleWritingScreen();
  }
}
