import 'package:flutter/material.dart';

class TabIndexProvider extends ChangeNotifier {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void changeTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }
}
