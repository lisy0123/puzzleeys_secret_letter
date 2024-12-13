import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class PuzzleScreenHandler {
  static void navigateScreen({
    required Color barrierColor,
    required Widget child,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  Widget buildIconButton({
    required String iconName,
    required String text,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: buildSideText(iconName: iconName, text: text, context: context),
    );
  }

  Widget buildSideText({
    required String iconName,
    required String text,
    required BuildContext context,
  }) {
    final isLargeIcon = iconName == 'bar_puzzle' || iconName == 'btn_back';
    final iconSize = isLargeIcon ? 140.0.w : 100.0.w;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/imgs/$iconName.svg', height: iconSize),
        SizedBox(width: 20.0.w),
        isLargeIcon
            ? CustomText.textDisplay(text: text, context: context)
            : CustomText.textSmall(text: text, context: context),
      ],
    );
  }
}
