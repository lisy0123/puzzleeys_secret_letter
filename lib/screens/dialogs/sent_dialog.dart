import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class SentDialog extends StatelessWidget {
  const SentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/imgs/icon_puzzle_mail.svg',
          height: 240.0.w,
        ),
        CustomText.textDisplay(
          text: CustomStrings.sentMessage,
          context: context,
        ),
      ],
    );
  }
}
