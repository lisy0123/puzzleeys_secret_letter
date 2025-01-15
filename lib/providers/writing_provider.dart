import 'package:flutter/material.dart';

class WritingProvider extends ChangeNotifier {
  double _opacity = 1.0;
  double get opacity => _opacity;

  void updateOpacity({bool? setToInitial}) {
    if (setToInitial ?? false) {
      _opacity = 1.0;
    } else {
      _opacity = _opacity == 0.0 ? 1.0 : 0.0;
    }
    notifyListeners();
  }
}
