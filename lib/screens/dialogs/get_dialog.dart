import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

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
        TiltedPuzzle(puzzleColor: puzzleColor),
        SizedBox(
          height: 340.0.w,
          width: double.infinity,
          child: CustomText.textDisplay(
            text: '글자수 30자글자수 30자글자수 30자글자수 30자글자dh',
            context: context,
          ),
        ),
        CustomButton(
          iconName: 'btn_puzzle',
          iconTitle: CustomStrings.get,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
