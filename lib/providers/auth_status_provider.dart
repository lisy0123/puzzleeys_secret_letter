import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStatusProvider with ChangeNotifier {
  late bool _isLoggedIn = true;
  late bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  void checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        '${dotenv.env['PROJECT_URL']}/functions/v1/api/auth/check_user');
    final token = Supabase.instance.client.auth.currentSession?.accessToken;

    if (token != null) {
      try {
        final response = await http.post(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );
        final responseData = jsonDecode(response.body);

        if (responseData['code'] != 200) {
          _isLoggedIn = false;
          throw Exception('Error: ${responseData['message']}');
        } else {
          _isLoggedIn = true;
        }
      } catch (error) {
        _isLoggedIn = false;
        throw Exception('Error during user verification: $error');
      }
    } else {
      _isLoggedIn = false;
    }
    _isLoading = false;
    notifyListeners();
  }
}
