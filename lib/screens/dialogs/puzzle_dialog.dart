import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class PuzzleDialog {
  static Widget screen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _puzzleImage(),
        Container(
          height: 340.0.w,
          child: TextSetting.textDisplay(
            text: '글자수 30자글자수 30자글자수 30자글자수 30자글자',
            context: context,
          ),
        ),
        CustomButton(
          iconName: 'button_puzzle',
          iconTitle: '담기',
          onTap: () {},
        ),
      ],
    );
  }

  static SvgPicture _puzzleImage() {
    return SvgPicture.asset(
      'assets/imgs/puzzle_white.svg',
      height: 500.0.w,
    );
  }
}
