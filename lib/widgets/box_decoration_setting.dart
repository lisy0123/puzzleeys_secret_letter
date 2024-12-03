import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class BoxDecorationSetting {
  static List<BoxShadow> _shadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        offset: const Offset(0, 8),
        blurRadius: 10,
      ),
    ];
  }

  static BoxDecoration boxDecorationIcon() {
    return BoxDecoration(
      boxShadow: _shadow(),
    );
  }

  static BoxDecoration _shadowBorder() {
    return BoxDecoration(
      boxShadow: _shadow(),
      border: Border.all(
        color: ColorSetting.colorBase,
        width: 2,
      ),
    );
  }

  static BoxDecoration boxDecorationShadowBorder() {
    return _shadowBorder().copyWith(
      borderRadius: BorderRadius.circular(10),
      color: ColorSetting.colorWhite,
    );
  }

  static BoxDecoration boxDecorationHomeAlertDialog() {
    return _shadowBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      color: ColorSetting.colorPaper,
    );
  }

  static BoxDecoration boxDecorationPuzzleBead({
    required List<Color> gradientColors,
  }) {
    return _shadowBorder().copyWith(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
      ),
    );
  }

  static BoxDecoration boxDecorationButton() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: ColorSetting.colorWhite,
      border: Border.all(
        color: ColorSetting.colorBase,
        width: 2,
      ),
    );
  }
}