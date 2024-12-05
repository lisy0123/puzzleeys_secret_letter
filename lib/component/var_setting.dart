import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class VarSetting {
  static final int puzzleNums = 9876;
  static final int diaNums = 1234;

  static final List<Color> myGradientColors = [
    ColorSetting.colorBlue,
    ColorSetting.colorPink,
  ];

  static const List<String> mainIconNameLists = [
    '전체',
    '주제',
    '개인',
    '상점',
  ];
  static const Map<String, String> iconNameLists = {
    'setting': '설 정',
    'list': '더 보 기',
    'bead': '감정 퍼즐 구슬',
    '0': '내 글',
    '1': '공 지',
    '2': '퀘스트',
    '3': '업 적',
    'alarm': '신고하기',
    'puzzle': '감정 담기',
  };
}
