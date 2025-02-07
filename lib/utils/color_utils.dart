import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class ColorUtils {
  static Color colorMatch({Color? baseColor, String? stringColor}) {
    final Map<dynamic, Color> colorMap = {
      CustomColors.colorPink: CustomColors.colorLightPink,
      CustomColors.colorRed: CustomColors.colorLightRed,
      CustomColors.colorOrange: CustomColors.colorLightOrange,
      CustomColors.colorYellow: CustomColors.colorLightYellow,
      CustomColors.colorGreen: CustomColors.colorLightGreen,
      CustomColors.colorSkyBlue: CustomColors.colorLightSkyBlue,
      CustomColors.colorBlue: CustomColors.colorLightBlue,
      CustomColors.colorPurple: CustomColors.colorLightPurple,

      'Base': Colors.white.withValues(alpha: 0.8),
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

  static String colorToString(Color color) {
    final Map<Color, String> colorMap = {
      CustomColors.colorPink: 'Pink',
      CustomColors.colorRed: 'Red',
      CustomColors.colorOrange: 'Orange',
      CustomColors.colorYellow: 'Yellow',
      CustomColors.colorGreen: 'Green',
      CustomColors.colorSkyBlue: 'SkyBlue',
      CustomColors.colorBlue: 'Blue',
      CustomColors.colorPurple: 'Purple',
    };
    if (colorMap[color] == null) {
      throw Exception('Error: Wrong color.');
    } else {
      return colorMap[color]!;
    }
  }
}
