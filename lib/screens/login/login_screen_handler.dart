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

class LoginScreenHandler {
  static Future<void> googleLogin(BuildContext context) async {
    try {
      final googleSignIn = await _initializeGoogleSignIn();
      final googleUser = await _signInWithGoogle(googleSignIn);
      final googleAuth = await googleUser!.authentication;
      await LoginValidate.validateTokens(
        googleAuth.accessToken,
        googleAuth.idToken,
      );
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      if (context.mounted) {
        final token = await context.read<FcmTokenProvider>().getFcm();
        final responseData = await apiRequest(
          '/api/auth/login',
          ApiType.post,
          headers: {'Content-Type': 'application/json'},
          bodies: {'fcm_token': token},
        );

        if (responseData['code'] == 200) {
          final userData = responseData['result'];
          final createdAt = Utils.convertUTCToKST(userData['created_at']);

          await Future.wait([
            SecureStorageUtils.save('userId', userData['user_id']),
            SecureStorageUtils.save('createdAt', createdAt),
            if (context.mounted)
              context.read<AuthStatusProvider>().checkLoginStatus(),
          ]);
        } else {
          throw Exception('Error: ${responseData['message']}');
        }
      }
    } catch (error) {
      throw Exception('Google login failed: $error');
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
      throw 'Failed to sign in with google: $error';
    }
  }

  static Future<void> appleLogin(BuildContext context) async {
    // TODO: Apple login
  }
}
