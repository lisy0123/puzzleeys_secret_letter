import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class BoxDecorations {
  static BoxShadow shadow() {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      offset: const Offset(0, 8),
      blurRadius: 10,
    );
  }

  static BoxDecoration _shadowBorder() {
    return BoxDecoration(
      boxShadow: [shadow()],
      border: Border.all(
        color: CustomColors.colorBase,
        width: 2,
      ),
    );
  }

  static BoxDecoration shadowBorder({
    double circular = 10.0,
    Color color = Colors.white,
  }) {
    return _shadowBorder().copyWith(
      borderRadius: BorderRadius.circular(circular),
      color: color,
    );
  }

  static BoxDecoration bead({required List<Color> myGradientColors}) {
    return _shadowBorder().copyWith(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: myGradientColors,
      ),
    );
  }

  static BoxDecoration colorList({
    required Color color,
    double borderRadius = 7.0,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: color,
      boxShadow: const [],
      border: Border.all(
        color: CustomColors.colorBase,
        width: 1.5,
      ),
    );
  }
}
