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
    '더보기',
  ];

  static const Map<String, String> iconNameLists = {
    'list': '더 보 기',
    'bead': '감정 퍼즐 구슬',
    'alarm': '신고하기',
    'get': '감정 담기',
    'put': '감정 넣기',
    '0': '계 정',
    '1': '내 글',
    '2': '알 람',
    '3': '임 무',
    '4': '???',
    '5': '업 적',
    '6': '공 지',
    '7': '문 의',
    '8': '설 정',
  };
}
