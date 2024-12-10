import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';

class BoxDecorationSetting {
  static BoxShadow shadow() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.5),
      offset: const Offset(0, 8),
      blurRadius: 10,
    );
  }

  static BoxDecoration shadowBorder() {
    return BoxDecoration(
      boxShadow: [shadow()],
      border: Border.all(
        color: ColorSetting.colorBase,
        width: 2,
      ),
    );
  }

  static BoxDecoration boxDecorationShadowBorder({
    double circular = 10.0,
    Color color = Colors.white,
  }) {
    return shadowBorder().copyWith(
      borderRadius: BorderRadius.circular(circular),
      color: color,
    );
  }

  static BoxDecoration boxDecorationBead(
      {required List<Color> myGradientColors}) {
    return shadowBorder().copyWith(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: myGradientColors,
      ),
    );
  }
}
