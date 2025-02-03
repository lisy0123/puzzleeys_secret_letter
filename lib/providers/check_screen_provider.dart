import 'package:flutter/material.dart';

class CheckScreenProvider extends ChangeNotifier {
  bool _check = false;
  bool get check => _check;

  Future<void> initialize() async {
    _check = false;
    notifyListeners();
  }

  void toggleCheck(bool toggle) {
    _check = toggle;
    notifyListeners();
  }
}
