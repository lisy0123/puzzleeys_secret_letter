import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/welcome_screen.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/feedback_email.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class QuestionDialog extends StatelessWidget {
  const QuestionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextButton(
              iconName: 'btn_puzzle',
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return WelcomeScreen();
                  },
                );
              },
              text: CustomStrings.howToUse,
              context: context,
            ),
            Utils.dialogDivider(),
            _buildTextButton(
              iconName: 'btn_mail',
              onTap: () => FeedbackEmail.send(),
              text: CustomStrings.feedback,
              context: context,
            ),
            Utils.dialogDivider(),
          ],
        ),
        GestureDetector(
          onTap: () => Utils.launchURL(CustomStrings.snsX),
          child: SvgPicture.asset('assets/imgs/sns_x.svg', height: 300.0.w),
        ),
      ],
    );
  }

  Widget _buildTextButton({
    required String iconName,
    required VoidCallback onTap,
    required String text,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.all(80.0.w),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/imgs/$iconName.svg', height: 34.0.h),
            SizedBox(width: 40.0.w),
            CustomText.textContent(text: text, context: context),
          ],
        ),
      ),
    );
  }
}
