import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStatusProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void checkLoginStatus() async {
    final token = await FlutterSecureStorage().read(key: 'access');
    _isLoggedIn = token != null;
    notifyListeners();
  }
}
