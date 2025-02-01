import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class PuzzleScaleProvider extends ChangeNotifier {
  double _scaleFactor = 0.5;
  double get scaleFactor => _scaleFactor;

  Future<void> initialize() async {
    final storedScale = await SharedPreferencesUtils.get('scaleFactor');
    if (storedScale != null) {
      _scaleFactor = double.tryParse(storedScale) ?? 0.5;
    } else {
      _scaleFactor = 0.5;
    }
    notifyListeners();
  }

  void toggleScale() {
    switch (_scaleFactor) {
      case 1.0:
        _scaleFactor = 0.75;
      case 0.75:
        _scaleFactor = 0.5;
      default:
        _scaleFactor = 1.0;
    }
    SharedPreferencesUtils.save('scaleFactor', _scaleFactor.toString());
    notifyListeners();
  }
}
