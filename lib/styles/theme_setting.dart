import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class ThemeSetting {
  static TextStyle _textMain({
    Color textColor = ColorSetting.colorBase,
    double fontSize = 100.0,
  }) {
    return TextStyle(
      fontSize: fontSize.w,
      letterSpacing: 3,
      height: 1.5,
      color: textColor,
    );
  }

  static TextStyle _textMainStroke({
    Color textColor = ColorSetting.colorWhite,
    double fontSize = 100.0,
  }) {
    return _textMain(textColor: textColor).copyWith(
        fontSize: fontSize.w,
        fontWeight: FontWeight.w900,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = textColor == ColorSetting.colorWhite
              ? textColor.withOpacity(0.9)
              : textColor);
  }

  static ThemeData themeSetting() {
    return ThemeData(
      fontFamily: 'BMJUA',
      textTheme: TextTheme(
        headlineLarge: _textMainStroke(),
        headlineMedium: _textMain(),
        labelLarge: _textMainStroke(textColor: ColorSetting.colorBase),
        labelMedium: _textMain(textColor: ColorSetting.colorWhite),
        titleLarge: _textMainStroke(fontSize: 120.0),
        titleMedium: _textMain(fontSize: 120.0),
      ),
    );
  }
}
