import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class ColorMatch {
  final Color baseColor;

  const ColorMatch(this.baseColor);

  Color call() {
    final colorMap = {
      CustomColors.colorPink: CustomColors.colorLightPink,
      CustomColors.colorRed: CustomColors.colorLightRed,
      CustomColors.colorOrange: CustomColors.colorLightOrange,
      CustomColors.colorYellow: CustomColors.colorLightYellow,
      CustomColors.colorGreen: CustomColors.colorLightGreen,
      CustomColors.colorSkyBlue: CustomColors.colorLightSkyBlue,
      CustomColors.colorBlue: CustomColors.colorLightBlue,
      CustomColors.colorPurple: CustomColors.colorLightPurple,

      CustomColors.colorLightPink: CustomColors.colorPink,
      CustomColors.colorLightRed: CustomColors.colorRed,
      CustomColors.colorLightOrange: CustomColors.colorOrange,
      CustomColors.colorLightYellow: CustomColors.colorYellow,
      CustomColors.colorLightGreen: CustomColors.colorGreen,
      CustomColors.colorLightSkyBlue: CustomColors.colorSkyBlue,
      CustomColors.colorLightBlue: CustomColors.colorBlue,
      CustomColors.colorLightPurple: CustomColors.colorPurple,
    };

    return colorMap[baseColor] ?? Colors.white;
  }
}
