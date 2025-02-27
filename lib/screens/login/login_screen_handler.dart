import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:puzzleeys_secret_letter/providers/auth_status_provider.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/providers/fcm_token_provider.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_validate.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginScreenHandler {
  static Future<void> googleLogin(BuildContext context) async {
    try {
      final googleSignIn = await _initializeGoogleSignIn();
      final googleUser = await _signInWithGoogle(googleSignIn);
      final googleAuth = await googleUser!.authentication;

      if (context.mounted) {
        await _handleLogin(
          context,
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
      }
    } catch (error) {
      throw Exception('Google login failed: $error');
    }
  }

  static Future<void> appleLogin(BuildContext context) async {
    try {
      final rawNonce = Supabase.instance.client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final appleCredentials = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      if (context.mounted) {
        await _handleLogin(
          context,
          provider: OAuthProvider.apple,
          idToken: appleCredentials.identityToken,
          nonce: rawNonce,
        );
      }
    } catch (error) {
      throw Exception('Apple login failed: $error');
    }
  }

  static Future<void> _handleLogin(
    BuildContext context, {
    required OAuthProvider provider,
    required String? idToken,
    String? accessToken,
    String? nonce,
  }) async {
    await LoginValidate.validateTokens(idToken, accessToken, nonce);
    await Supabase.instance.client.auth.signInWithIdToken(
      provider: provider,
      idToken: idToken!,
      accessToken: provider == OAuthProvider.google ? accessToken : null,
      nonce: provider == OAuthProvider.apple ? nonce : null,
    );

    if (context.mounted) {
      final String token = await context.read<FcmTokenProvider>().getFcm();
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final Map<String, String> bodies = {'fcm_token': token};

      final responseData = await apiRequest(
        '/api/auth/login',
        ApiType.post,
        headers: headers,
        bodies: bodies,
      );

      if (responseData['code'] == 200) {
        final userData = responseData['result'];
        final createdAt = Utils.convertUTCToKST(userData['created_at']);

        await Future.wait([
          SecureStorageUtils.save('userId', userData['user_id']),
          SecureStorageUtils.save('createdAt', createdAt),
        ]);
        if (context.mounted) {
          await context.read<AuthStatusProvider>().checkLoginStatus();
        }
      } else {
        throw Exception('Error: ${responseData['message']}');
      }
    }
  }

  static Future<GoogleSignIn> _initializeGoogleSignIn() async {
    final webClientId = dotenv.env['WEB_ID'];
    final iosClientId = dotenv.env['IOS_ID'];
    LoginValidate.validateClientIds(webClientId, iosClientId);

    return GoogleSignIn(
      serverClientId: webClientId!,
      clientId: iosClientId!,
    );
  }

  static Future<GoogleSignInAccount?> _signInWithGoogle(
      GoogleSignIn googleSignIn) async {
    try {
      final googleUser = await googleSignIn.signIn();
      LoginValidate.validateGoogleUser(googleUser);
      return googleUser;
    } catch (error) {
      throw Exception('Failed to sign in with Google: $error');
    }
  }
}
