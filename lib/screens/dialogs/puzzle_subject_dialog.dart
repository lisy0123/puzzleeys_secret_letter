import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class PuzzleSubjectDialog extends StatelessWidget {
  final Color puzzleColor;
  final String puzzleText;

  const PuzzleSubjectDialog({
    super.key,
    required this.puzzleColor,
    required this.puzzleText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Utils.tiltedPuzzle(puzzleColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: CustomText.textContentTitle(
                  text: '${CustomStrings.addToday}\n$puzzleText',
                  context: context,
                ),
              ),
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }
}
