import 'package:flutter/material.dart';

class WritingProvider extends ChangeNotifier {
  late bool isVisible = true;

  void toggleVisibility() {
    if (isVisible) {
      isVisible = false;
    } else {
      isVisible = true;
    }
    notifyListeners();
  }
}
