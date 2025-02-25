import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/utils/feedback_email.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class QuestionDialog extends StatelessWidget {
  const QuestionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(
          iconName: 'bar_puzzle',
          iconTitle: CustomStrings.howToUse,
          onTap: () => Utils.launchURL(CustomStrings.howToUseUrl),
        ),
        Utils.dialogDivider(),
        CustomButton(
          iconName: 'btn_mail',
          iconTitle: CustomStrings.feedback,
          onTap: () => FeedbackEmail.send(),
        ),
        Utils.dialogDivider(),
        GestureDetector(
          onTap: () => Utils.launchURL(CustomStrings.snsX),
          child: SvgPicture.asset('assets/imgs/sns_x.svg', height: 300.0.w),
        )
      ],
    );
  }
}
