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
  ];
  static const Map<String, String> iconNameLists = {
    "list": "더 보 기",
    "0": "내 글",
    "1": "감정 퍼즐",
    "2": "감정 퍼즐 구슬",
    "3": "퀘스트",
    "4": "업 적",
    "5": "상 점",
    "6": "공 지",
    "7": "문 의",
    "8": "설 정", // same with setting
  };
  static const List<String> listContentLists = [
    '내 글',
    '퍼 즐',
    '구 슬',
    "퀘스트",
    "업 적",
    '상 점',
    "공 지",
    "문 의",
    "설 정",
  ];
}
