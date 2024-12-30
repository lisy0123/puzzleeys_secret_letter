import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class PuzzleLoadingScreen extends StatelessWidget {
  final String text;

  const PuzzleLoadingScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -pi / 4,
              child: CustomPaint(
                size: Size(280.0.w, 280.0.w),
                painter: TiltedPuzzlePiece(
                  puzzleColor: Colors.white,
                  strokeWidth: 1.5,
                ),
              ),
            ),
            SizedBox(height: 40.0.w),
            CustomText.textDisplay(
              text: text,
              stroke: true,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
