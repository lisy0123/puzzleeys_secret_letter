import 'package:flutter/material.dart';

class LoggedBeforeProvider extends ChangeNotifier {
  bool _loggedInBefore = true;
  bool get loggedInBefore => _loggedInBefore;

  void loggedCheckToggle(bool toggle) {
    if (_loggedInBefore != toggle) {
      _loggedInBefore = toggle;
      notifyListeners();
    }
  }
}
