import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreenHandler {
  static Future<void> googleLogin() async {
    try {
      final googleSignIn = await _initializeGoogleSignIn();
      final googleUser = await _signInWithGoogle(googleSignIn);
      final googleAuth = await googleUser!.authentication;

      await _validateTokens(googleAuth.accessToken, googleAuth.idToken);
      final response =
          await _supabaseLogin(googleAuth.accessToken!, googleAuth.idToken!);
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
    if (accessToken == null || idToken == null) {
      throw 'Access Token or ID Token is missing.';
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
        throw 'User authentication failed.';
      }

      await _insertUserIfNeeded(response);

      return response;
    } catch (e) {
      throw 'Error during Supabase login or user insertion: $e';
    }
  }

  static Future<void> _insertUserIfNeeded(AuthResponse response) async {
    final userId = response.user!.id;
    final existingUserResponse = await Supabase.instance.client
        .from('user_list')
        .select()
        .eq('auth_user_id', userId)
        .maybeSingle();

    if (existingUserResponse == null) {
      final insertResponse =
          await Supabase.instance.client.from('user_list').insert({
        'id': userId,
        'email': response.user!.email,
        'auth_user_id': response.user!.id,
        'provider': response.user!.appMetadata['provider'],
        'created_at': response.user!.createdAt,
      }).select();

      if (insertResponse.isEmpty) {
        throw 'Error inserting user data into user_table: $insertResponse';
      }
    }
  }

  static void _validateLoginResponse(AuthResponse response) {
    if (response.session == null || response.user == null) {
      throw 'Supabase login failed: No session or user data found.';
    }
  }
}
