import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStatusProvider with ChangeNotifier {
  late bool _isLoggedIn = true;
  bool get isLoggedIn => _isLoggedIn;

  void checkLoginStatus() async {
    final storedId = await FlutterSecureStorage().read(key: 'user_id');
    _isLoggedIn = storedId != null;
    if (_isLoggedIn) {
      if (storedId!.isEmpty) {
        _isLoggedIn = false;
      }
      final url =
          Uri.parse('${dotenv.env['PROJECT_URL']}/functions/v1/api/auth/check_user');

      try {
        final response = await http.post(
          url,
          headers: {'Authorization': 'Bearer $storedId'},
        );

        final responseData = jsonDecode(response.body);

        if (responseData['code'] != 200 ||
            responseData['result']['exists'] != 'Y') {
          _isLoggedIn = false;
          throw Exception('Error: ${responseData['message']}');
        }
      } catch (error) {
        _isLoggedIn = false;
        throw Exception('Error during user verification: $error');
      }
    }
    notifyListeners();
  }
}
