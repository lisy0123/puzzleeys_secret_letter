import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(CustomStrings.terms, UrlStrings.termsUrl, context),
        Utils.dialogDivider(),
        _buildText(
          CustomStrings.privacyPolicy,
          UrlStrings.privacyPolicyUrl,
          context,
        ),
        Utils.dialogDivider(),
        _buildText(
          CustomStrings.copyRightPolicy,
          UrlStrings.copyRightPolicyUrl,
          context,
        ),
        Utils.dialogDivider(),
      ],
    );
  }

  Widget _buildText(String text, String url, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(80.0.w),
      child: GestureDetector(
        onTap: () => Utils.launchURL(url),
        child: CustomText.textContent(text: '- $text', context: context),
      ),
    );
  }
}
