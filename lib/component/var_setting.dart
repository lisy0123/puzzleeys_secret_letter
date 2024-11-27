import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class VarSetting {
  static final int puzzleNums = 9876543210;
  static final int worldPuzzleNums = 123;
  static final int myPuzzleNums = 456;

  static final List<Color> myGradientColors = [
    ColorSetting.colorBlue,
    ColorSetting.colorPink,
  ];
  static final List<Color> worldGradientColors = [
    ColorSetting.colorOrange,
    ColorSetting.colorGreen,
    ColorSetting.colorPink,
  ];

  static const Map<String, String> iconNameLists = {
    "setting": "설 정",
    "0": "공 지",
    "1": "테 마",
    "2": "업 적",
    "3": "상 점",
    "": "감정 퍼즐 구슬",
  };

}