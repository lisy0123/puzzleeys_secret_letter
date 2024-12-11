import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class ThemeSetting {
  static TextStyle _textMain({
    Color textColor = ColorSetting.colorBase,
    double fontSize = 90.0,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      letterSpacing: 2,
      height: 1.5,
      color: textColor,
    );
  }

  static TextStyle _textMainStroke({
    Color textColor = Colors.white,
    double fontSize = 90.0,
  }) {
    return _textMain(textColor: textColor).copyWith(
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w900,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = textColor);
  }

  static ThemeData themeSetting() {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      scaffoldBackgroundColor: ColorSetting.colorBase,
      fontFamily: 'BMJUA',
      textTheme: TextTheme(
        // top bar nums
        headlineLarge: _textMainStroke(textColor: ColorSetting.colorBase),
        headlineMedium: _textMain(textColor: Colors.white),
        // dialog title
        titleLarge: _textMainStroke(fontSize: 110.0),
        titleMedium: _textMain(fontSize: 110.0),
        // display: icon button, puzzle content
        displayMedium: _textMain(fontSize: 80.0),
        // icon disable
        displaySmall: _textMain(
          fontSize: 80.0,
          textColor: ColorSetting.colorBase.withOpacity(0.4),
        ),
        // bottom bar, small
        labelLarge: _textMain(fontSize: 70.0),
        labelMedium: _textMain(
          fontSize: 70.0,
          textColor: ColorSetting.colorBase.withOpacity(0.4),
        ),
      ),
    );
  }
}
