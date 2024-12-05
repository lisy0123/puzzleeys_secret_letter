import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class ColorMatch {
  final Color baseColor;

  const ColorMatch({required this.baseColor});

  Color call() {
    if (baseColor == ColorSetting.colorPink) {
      return ColorSetting.colorLightPink;
    } else if (baseColor == ColorSetting.colorRed) {
      return ColorSetting.colorLightRed;
    } else if (baseColor == ColorSetting.colorOrange) {
      return ColorSetting.colorLightOrange;
    } else if (baseColor == ColorSetting.colorYellow) {
      return ColorSetting.colorLightYellow;
    } else if (baseColor == ColorSetting.colorGreen) {
      return ColorSetting.colorLightGreen;
    } else if (baseColor == ColorSetting.colorSkyBlue) {
      return ColorSetting.colorLightSkyBlue;
    } else if (baseColor == ColorSetting.colorBlue) {
      return ColorSetting.colorLightBlue;
    } else {
      return ColorSetting.colorLightPurple;
    }
  }
}
