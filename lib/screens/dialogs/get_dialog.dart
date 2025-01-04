import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class GetDialog extends StatelessWidget {
  final Color puzzleColor;

  const GetDialog({
    super.key,
    required this.puzzleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TiltedPuzzle(puzzleColor: puzzleColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
            child: SizedBox(
              height: 340.0.w,
              width: double.infinity,
              child: CustomText.textContent(
                text: '글자수 30자글자수 30자글자수 30자글자수 30자글자dh',
                context: context,
              ),
            ),
          ),
          CustomButton(
            iconName: 'btn_puzzle',
            iconTitle: CustomStrings.get,
            onTap: () {
              Navigator.pop(context);
              CustomOverlay.show(
                text: MessageStrings.overlayMessages[OverlayType.getPuzzle]![1],
                delayed: 2500,
                puzzleVis: true,
                puzzleNum:
                    MessageStrings.overlayMessages[OverlayType.getPuzzle]![0],
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
