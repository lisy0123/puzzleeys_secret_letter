import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStatusProvider with ChangeNotifier {
  bool _isLoggedIn = true;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  Future<void> checkLoginStatus() async {
    _updateLoading(true);

    try {
      final currentSession = Supabase.instance.client.auth.currentSession;
      if (currentSession == null) {
        _updateLoginStatus(false);
        return;
      }

      final responseData =
          await apiRequest('/api/auth/check_user', ApiType.get);

      if (responseData['code'] == 200) {
        _updateLoginStatus(true);
      } else {
        _updateLoginStatus(false);
      }
    } catch (error) {
      _updateLoginStatus(false);
      if (!error.toString().contains('Invalid or expired JWT')) {
        debugPrint('Error during user verification: $error');
      }
    } finally {
      _updateLoading(false);
    }
  }

  void _updateLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void _updateLoginStatus(bool value) {
    if (_isLoggedIn != value) {
      _isLoggedIn = value;
      notifyListeners();
    }
  }
}
