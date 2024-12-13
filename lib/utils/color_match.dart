import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class ColorMatch {
  final Color baseColor;

  const ColorMatch(this.baseColor);

  Color call() {
    if (baseColor == CustomColors.colorPink) {
      return CustomColors.colorLightPink;
    } else if (baseColor == CustomColors.colorRed) {
      return CustomColors.colorLightRed;
    } else if (baseColor == CustomColors.colorOrange) {
      return CustomColors.colorLightOrange;
    } else if (baseColor == CustomColors.colorYellow) {
      return CustomColors.colorLightYellow;
    } else if (baseColor == CustomColors.colorGreen) {
      return CustomColors.colorLightGreen;
    } else if (baseColor == CustomColors.colorSkyBlue) {
      return CustomColors.colorLightSkyBlue;
    } else if (baseColor == CustomColors.colorBlue) {
      return CustomColors.colorLightBlue;
    } else if (baseColor == CustomColors.colorPurple) {
      return CustomColors.colorLightPurple;
    } else if (baseColor == CustomColors.colorPink) {
      return CustomColors.colorLightPink;
    } else if (baseColor == CustomColors.colorLightRed) {
      return CustomColors.colorRed;
    } else if (baseColor == CustomColors.colorLightOrange) {
      return CustomColors.colorOrange;
    } else if (baseColor == CustomColors.colorLightYellow) {
      return CustomColors.colorYellow;
    } else if (baseColor == CustomColors.colorLightGreen) {
      return CustomColors.colorGreen;
    } else if (baseColor == CustomColors.colorLightSkyBlue) {
      return CustomColors.colorSkyBlue;
    } else if (baseColor == CustomColors.colorLightBlue) {
      return CustomColors.colorBlue;
    } else if (baseColor == CustomColors.colorLightPurple) {
      return CustomColors.colorPurple;
    } else {
      return CustomColors.colorPink;
    }
  }
}
