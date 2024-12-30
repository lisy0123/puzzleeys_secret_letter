import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStatusProvider with ChangeNotifier {
  late bool _isLoggedIn = true;
  late bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  void checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    if (token != null) {
      try {
        final responseData =
        await apiRequest('/api/auth/check_user', ApiType.get);

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
