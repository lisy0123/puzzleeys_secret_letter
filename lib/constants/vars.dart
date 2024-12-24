import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';

class CustomVars {
  static final String version = '0.8.1';

  static final int puzzleNums = 9876;
  static final int diaNums = 1234;

  static final List<Color> myGradientColors = [
    CustomColors.colorBlue,
    CustomColors.colorPink,
  ];

  static final List<Color> myColorPickers = [
    CustomColors.colorPink,
    CustomColors.colorRed,
    CustomColors.colorOrange,
    CustomColors.colorYellow,
    CustomColors.colorGreen,
    CustomColors.colorSkyBlue,
    CustomColors.colorBlue,
    CustomColors.colorPurple,
  ];

  static Map<Enum, QuestData> questDatabases = {
    QuestType.attendance: QuestData(6, 60),
    QuestType.writePuzzle: QuestData(5, 5000),
    QuestType.getPuzzle: QuestData(3, 300),
    QuestType.writeReply: QuestData(8, 80),
  };
}
