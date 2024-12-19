import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class LoginScreenHandler {
  static Future<void> googleLogin() async {
    try {
      final googleSignIn = await _initializeGoogleSignIn();
      final googleUser = await _signInWithGoogle(googleSignIn);

      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      await _validateTokens(accessToken, idToken);

      final response = await _supabaseLogin(accessToken!, idToken!);
      _validateLoginResponse(response);
    } catch (e) {
      throw 'Google login failed: $e';
    }
  }

  static Future<GoogleSignIn> _initializeGoogleSignIn() async {
    final webClientId = dotenv.env['WEB_ID'];
    final iosClientId = dotenv.env['IOS_ID'];
    _validateClientIds(webClientId, iosClientId);

    return GoogleSignIn(
      serverClientId: webClientId!,
      clientId: iosClientId!,
    );
  }

  static Future<GoogleSignInAccount?> _signInWithGoogle(
      GoogleSignIn googleSignIn) async {
    final googleUser = await googleSignIn.signIn();
    _validateGoogleUser(googleUser);
    return googleUser;
  }

  static Future<void> appleLogin() async {
    // TODO: Apple login
  }

  static void _validateClientIds(String? webClientId, String? iosClientId) {
    if (webClientId == null || iosClientId == null) {
      throw 'Missing client ID for either web or iOS in environment variables.';
    }
  }

  static void _validateGoogleUser(GoogleSignInAccount? googleUser) {
    if (googleUser == null) {
      throw 'Google Sign-In failed or was canceled.';
    }
  }

  static Future<void> _validateTokens(
      String? accessToken, String? idToken) async {
    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
  }

  static Future<AuthResponse> _supabaseLogin(
      String accessToken, String idToken) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        accessToken: accessToken,
        idToken: idToken,
      );
      if (response.user == null) {
        throw 'User authentication failed';
      }

      try {
        final idString = response.user!.id;
        final id = base64.encode(List<int>.generate(16, (i) => int.parse(
              idString.replaceAll('-', '')[i * 2] +
                    idString.replaceAll('-', '')[i * 2 + 1],
                radix: 16)));
        final existingUserResponse = await Supabase.instance.client
            .from('user_list')
            .select()
            .eq('id', id)
            .maybeSingle();

        if (existingUserResponse == null) {
          final insertResponse =
              await Supabase.instance.client.from('user_list').insert({
            'id': id,
            'email': response.user!.email,
            'auth_user_id': response.user!.id,
            'provider': response.user!.appMetadata['provider'],
            'created_at': response.user!.createdAt,
          }).select();

          if (insertResponse.isEmpty) {
            throw 'Error inserting user data into user_table: $insertResponse';
          }
        }
      } catch (e) {
        throw "Insert Error: $e";
      }

      return response;
    } catch (e) {
      throw 'Error during login or user insertion: $e';
    }
  }

  static void _validateLoginResponse(AuthResponse response) {
    if (response.session == null || response.user == null) {
      throw 'Supabase login failed: No session or user data found.';
    }
  }
}
