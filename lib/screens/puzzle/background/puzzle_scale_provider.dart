import 'package:flutter/material.dart';

class PuzzleScaleProvider extends ChangeNotifier {
  double scaleFactor = 1.0;

  void toggleScale() {
    switch (scaleFactor) {
      case 1.0:
        scaleFactor = 0.75;
      case 0.75:
        scaleFactor = 0.5;
      default:
        scaleFactor = 1.0;
    }
    notifyListeners();
  }
}
