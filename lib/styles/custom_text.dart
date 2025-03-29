import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class CustomText {
  static List<Text> _buildTextVariants({
    required String text,
    required List<TextStyle?> styles,
  }) {
    return styles
        .map((styles) => Text(
              text,
              style: styles,
              textAlign: TextAlign.center,
            ))
        .toList();
  }

  static Stack _textTitle({
    required String text,
    required List<TextStyle?> textStyle,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: _buildTextVariants(text: text, styles: textStyle),
    );
  }

  static Stack textTopBarNums({
    required int puzzleNums,
    required BuildContext context,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: _buildTextVariants(
        text: puzzleNums.toString(),
        styles: [
          Theme.of(context).textTheme.headlineLarge,
          Theme.of(context).textTheme.headlineMedium,
        ],
      ),
    );
  }

  static Stack textDialogTitle({
    required String text,
    required BuildContext context,
  }) {
    return _textTitle(
      text: text,
      textStyle: [
        Theme.of(context).textTheme.titleLarge,
        Theme.of(context).textTheme.titleMedium,
      ],
    );
  }

  static Stack textDisplay({
    required String text,
    bool disable = false,
    bool stroke = false,
    required BuildContext context,
  }) {
    final List<TextStyle?> textStyle;
    if (disable) {
      textStyle = [Theme.of(context).textTheme.displaySmall];
    } else {
      if (stroke) {
        textStyle = [
          Theme.of(context).textTheme.bodySmall,
          Theme.of(context).textTheme.displayMedium,
        ];
      } else {
        textStyle = [Theme.of(context).textTheme.displayMedium];
      }
    }

    return _textTitle(text: text, textStyle: textStyle);
  }

  static Text textSmall({
    required String text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  static Text textContent({
    required String text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
    );
  }

  static Text textContentTitle({
    required String text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall,
      textAlign: TextAlign.center,
    );
  }

  static Text overlayText(String text, {bool fontFamily = false}) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: fontFamily ? 84.sp : 78.0.sp,
        fontFamily: fontFamily ? 'BMJUA' : 'NANUM',
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  static Text dialogText(String text, {bool gray = false}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: gray
            ? CustomColors.colorBase.withValues(alpha: 0.6)
            : CustomColors.colorBase,
        fontFamily: 'NANUM',
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        fontSize: gray ? 70.sp : 74.0.sp,
      ),
    );
  }

  static Text agreementText(String text, [bool underline = true]) {
    return Text(
      text,
      textAlign: TextAlign.end,
      style: TextStyle(
        color: underline
            ? CustomColors.colorBase.withValues(alpha: 0.6)
            : CustomColors.colorBase,
        fontFamily: 'NANUM',
        fontSize: underline ? 74.0.sp : 84.0.sp,
        fontWeight: FontWeight.w900,
        decoration: underline ? TextDecoration.underline : null,
      ),
    );
  }
}
