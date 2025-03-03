import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class PuzzleScaleProvider extends ChangeNotifier {
  double _scaleFactor = 0.75;
  double get scaleFactor => _scaleFactor;

  PuzzleScaleProvider() {
    _initialize();
  }

  void _initialize() async {
    _scaleFactor = await SharedPreferencesUtils.getDouble('scaleFactor') ?? 0.75;
    notifyListeners();
  }

  void updateScale(double newScaleFactor) {
    _scaleFactor = newScaleFactor;
    SharedPreferencesUtils.saveDouble('scaleFactor', _scaleFactor);
    notifyListeners();
  }
}
