import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class OnboardingDialog extends StatelessWidget {
  const OnboardingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2000.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText.textDisplay(
            text: WelcomeStrings.globalContent,
            context: context,
          ),
          _buildButton(PuzzleType.global, context),
          Utils.dialogDivider(),
          CustomText.textDisplay(
            text: WelcomeStrings.personalContent,
            context: context,
          ),
          _buildButton(PuzzleType.personal, context),
        ],
      ),
    );
  }

  Widget _buildButton(PuzzleType puzzleType, BuildContext context) {
    late String iconName;
    late String iconTitle;

    if (puzzleType == PuzzleType.global) {
      iconName = 'icon_0';
      iconTitle = WelcomeStrings.global;
    } else {
      iconName = 'icon_2';
      iconTitle = WelcomeStrings.personal;
    }

    return CustomButton(
      iconName: iconName,
      iconTitle: iconTitle,
      onTap: () {
        Navigator.pop(context);
        PuzzleScreenHandler.navigateScreen(
          barrierColor: Colors.white70,
          child: PuzzleWritingScreen(puzzleType: puzzleType, reply: false),
          context: context,
        );
      },
    );
  }
}
