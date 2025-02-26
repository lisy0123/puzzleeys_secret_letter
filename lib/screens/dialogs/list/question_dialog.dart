import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/feedback_email.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

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
              'btn_puzzle',
              () => Utils.launchURL(CustomStrings.howToUseUrl),
              CustomStrings.howToUse,
              context,
            ),
            Utils.dialogDivider(),
            _buildTextButton(
              'btn_mail',
              () => FeedbackEmail.send(),
              CustomStrings.feedback,
              context,
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

  Widget _buildTextButton(
    String iconName,
    VoidCallback onTap,
    String text,
    BuildContext context,
  ) {
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
