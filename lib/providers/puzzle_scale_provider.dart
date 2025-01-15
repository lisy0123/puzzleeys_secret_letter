import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/secure_storage_utils.dart';

class PuzzleScaleProvider extends ChangeNotifier {
  double _scaleFactor = 1.0;
  double get scaleFactor => _scaleFactor;

  PuzzleScaleProvider() {
    _loadScaleFactor();
  }

  Future<void> _loadScaleFactor() async {
    final storedScale = await SecureStorageUtils.get('scaleFactor');
    if (storedScale != null) {
      _scaleFactor = double.tryParse(storedScale) ?? 1.0;
    } else {
      _scaleFactor = 1.0;
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
    SecureStorageUtils.save('scaleFactor', _scaleFactor.toString());
    notifyListeners();
  }
}
