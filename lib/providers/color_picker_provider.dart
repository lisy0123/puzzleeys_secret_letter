import 'package:flutter/material.dart';

class ColorPickerProvider extends ChangeNotifier {
  double _opacity = 1.0;
  Color _selectedColor = Colors.white;

  double get opacity => _opacity;

  void updateOpacity({bool? setToInitial}) {
    if (setToInitial ?? false) {
      _opacity = 1.0;
    } else {
      _opacity = _opacity == 0.0 ? 1.0 : 0.0;
    }
    notifyListeners();
  }

  Color get selectedColor => _selectedColor;

  void updateColor({bool? setToInitial, Color color = Colors.white}) {
    if (setToInitial ?? false) {
      _selectedColor = Colors.white;
    } else {
      _selectedColor = color;
    }
    notifyListeners();
  }
}
