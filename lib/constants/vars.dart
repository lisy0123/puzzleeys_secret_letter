import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';

class CustomVars {
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
