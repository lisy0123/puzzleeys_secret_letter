import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class BoxDecorationSetting {
  static List<BoxShadow> _shadow({
    double opacity = 0.5,
}) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(opacity),
        offset: const Offset(0, 8),
        blurRadius: 20,
      ),
    ];
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

  static BoxDecoration boxDecorationShadowBorder() {
    return _shadowBorder().copyWith(
      borderRadius: BorderRadius.circular(8),
      color: ColorSetting.colorWhite,
    );
  }

  static BoxDecoration boxDecorationMainIcon() {
    return BoxDecoration(
      boxShadow: _shadow(opacity: 0.3),
    );
  }
}