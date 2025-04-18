import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
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
              iconName: 'btn_mail',
              onTap: () => FeedbackEmail.send(),
              text: CustomStrings.feedback,
              context: context,
            ),
            Utils.dialogDivider(),
          ],
        ),
        _buildSns(),
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

  Widget _buildSns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Utils.launchURL(UrlStrings.snsInsta),
          child: SvgPicture.asset('assets/imgs/sns_insta.svg', height: 240.0.w),
        ),
        SizedBox(width: 40.0.w),
        GestureDetector(
          onTap: () => Utils.launchURL(UrlStrings.snsX),
          child: SvgPicture.asset('assets/imgs/sns_x.svg', height: 300.0.w),
        ),
      ],
    );
  }
}
