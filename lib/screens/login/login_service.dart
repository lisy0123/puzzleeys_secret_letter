import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  static Future<void> supabaseLogin(BuildContext context) async {
    final url =
        Uri.parse('${dotenv.env['PROJECT_URL']}/functions/v1/api/auth/login');
    final token = Supabase.instance.client.auth.currentSession?.accessToken;

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
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
