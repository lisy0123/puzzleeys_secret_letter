import 'package:flutter/material.dart';

class PuzzleScreenProvider extends ChangeNotifier {
  bool _screenCheck = false;
  double _screenOpacity = 1.0;

  bool get screenCheck => _screenCheck;
  double get screenOpacity => _screenOpacity;

  void screenCheckToggle(bool toggle) {
    if (_screenCheck != toggle) {
      _screenCheck = toggle;
      notifyListeners();
    }
  }

  void updateScreenOpacity({bool? setToInitial}) {
    if (setToInitial ?? false) {
      _screenOpacity = 1.0;
    } else {
      _screenOpacity = _screenOpacity == 0.0 ? 1.0 : 0.0;
    }
    notifyListeners();
  }
}
