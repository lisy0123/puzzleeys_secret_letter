import 'package:flutter/material.dart';

class DeleteDialogProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateLoading({required bool setLoading}) {
    _isLoading = setLoading;
    notifyListeners();
  }
}
