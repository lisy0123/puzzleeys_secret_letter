import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/puzzle_tilted_piece.dart';
import 'package:puzzleeys_secret_letter/styles/text_setting.dart';

class GetDialog extends StatelessWidget {
  final Color puzzleColor;

  const GetDialog({
    super.key,
    required this.puzzleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        puzzleImage(puzzleColor),
        SizedBox(
          height: 340.0.w,
          width: double.infinity,
          child: TextSetting.textDisplay(
            text: '글자수 30자글자수 30자글자수 30자글자수 30자글자dh',
            context: context,
          ),
        ),
        CustomButton(
          iconName: 'btn_puzzle',
          iconTitle: '담 기',
          onTap: () {},
        ),
      ],
    );
  }

  static Widget puzzleImage(Color puzzleColor) {
    return CustomPaint(
      size: Size(600.0.w, 600.0.w),
      painter: PuzzleTiltedPiece(puzzleColor: puzzleColor),
    );
  }
}
