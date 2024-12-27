import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';

class LoginService {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> supabaseLogin(
    String accessToken,
    String idToken,
    BuildContext context,
  ) async {
    final url =
        Uri.parse('${dotenv.env['PROJECT_URL']}/functions/v1/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken,$idToken'},
      );

      final responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
        await _secureStorage.write(key: 'access', value: 'ACCESS');
        if (context.mounted) {
          context.read<AuthStatusProvider>().checkLoginStatus();
        }
      } else {
        throw Exception('Error: ${responseData['message']}');
      }
    } catch (error) {
      throw Exception('Error during login: $error');
    }
  }
}
