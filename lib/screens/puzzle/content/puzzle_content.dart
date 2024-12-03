import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleContent extends StatefulWidget {
  final int row;
  final int column;
  final int index;
  final double puzzleHeight;
  final double scaleFactor;

  const PuzzleContent({
    super.key,
    required this.row,
    required this.column,
    required this.index,
    required this.puzzleHeight,
    required this.scaleFactor,
  });

  @override
  State<PuzzleContent> createState() => _PuzzleContentState();
}

class _PuzzleContentState extends State<PuzzleContent> {
  double startDragY = 0;

  @override
  Widget build(BuildContext context) {
    final double rotateAngle = (widget.row % 2 == widget.column % 2)
        ? 90 * math.pi / 180
        : 90 * math.pi / 90;
    final puzzleColor = ColorSetting.colorRed;

    return LayoutId(
      id: widget.index,
      child: GestureDetector(
        onDoubleTap: () => _build(puzzleColor),
        child: Transform.rotate(
          angle: rotateAngle,
          child: SvgPicture.asset(
            'assets/imgs/board_puzzle.svg',
            height: widget.puzzleHeight * widget.scaleFactor,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              puzzleColor.withOpacity(0.7),
              BlendMode.srcATop,
            ),
          ),
        ),
      ),
    );
  }

  void _build(Color puzzleColor) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) {
        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          child: Center(
            child: Stack(
              children: [
                Container(
                  color: puzzleColor.withOpacity(0.7),
                ),
                Container(
                  alignment: Alignment.center,
                  color: ColorSetting.colorWhite.withOpacity(0.1),
                  child: Container(
                    margin: EdgeInsets.all(180.0.w),
                    child: PuzzleDetail(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    double dragDistance = details.globalPosition.dy - startDragY;

    if (dragDistance > 10) {
      Navigator.pop(context);
    };
    if (dragDistance < -10) {
      debugPrint('mail!');
    };
  }
}