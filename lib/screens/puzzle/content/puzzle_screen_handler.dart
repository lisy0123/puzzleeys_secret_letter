import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/text_setting.dart';

class PuzzleScreenHandler {
  static void navigateScreen({
    required Color barrierColor,
    required Widget child,
    required BuildContext context,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const Offset begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Widget buildIconButton({
    required String iconName,
    required String text,
    required Function onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: buildSideText(iconName: iconName, text: text, context: context),
    );
  }

  Widget buildSideText({
    required String iconName,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/imgs/$iconName.svg',
          height: iconName == 'bar_puzzle' ? 120.0.w : 100.0.w,
        ),
        SizedBox(width: 20.0.w),
        if (iconName == 'bar_puzzle')
          TextSetting.textDisplay(text: text, context: context)
        else
          TextSetting.textSmall(text: text, context: context),
      ],
    );
  }
}
