import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class ColorMatch {
  final Color? baseColor;
  final String? stringColor;

  const ColorMatch({this.baseColor, this.stringColor});

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
      'Pink': CustomColors.colorPink,
      'Red': CustomColors.colorRed,
      'Orange': CustomColors.colorOrange,
      'Yellow': CustomColors.colorYellow,
      'Green': CustomColors.colorGreen,
      'SkyBlue': CustomColors.colorSkyBlue,
      'Blue': CustomColors.colorBlue,
      'Purple': CustomColors.colorPurple,
    };
    if (baseColor != null) {
      return colorMap[baseColor] ?? Colors.white;
    } else if (stringColor != null) {
      return colorMap[stringColor] ?? Colors.white;
    } else {
      return Colors.white;
    }
  }
}
