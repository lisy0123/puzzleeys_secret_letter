import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class ColorMatch {
  final Color baseColor;

  const ColorMatch(this.baseColor);

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
    } else if (baseColor == ColorSetting.colorPurple) {
      return ColorSetting.colorLightPurple;
    } else if (baseColor == ColorSetting.colorPink) {
      return ColorSetting.colorLightPink;
    } else if (baseColor == ColorSetting.colorLightRed) {
      return ColorSetting.colorRed;
    } else if (baseColor == ColorSetting.colorLightOrange) {
      return ColorSetting.colorOrange;
    } else if (baseColor == ColorSetting.colorLightYellow) {
      return ColorSetting.colorYellow;
    } else if (baseColor == ColorSetting.colorLightGreen) {
      return ColorSetting.colorGreen;
    } else if (baseColor == ColorSetting.colorLightSkyBlue) {
      return ColorSetting.colorSkyBlue;
    } else if (baseColor == ColorSetting.colorLightBlue) {
      return ColorSetting.colorBlue;
    } else if (baseColor == ColorSetting.colorLightPurple) {
      return ColorSetting.colorPurple;
    } else {
      return ColorSetting.colorPink;
    }
  }
}
