import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_service.dart';
import 'package:puzzleeys_secret_letter/screens/login/login_validate.dart';
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
        await LoginService.supabaseLogin(context);
      }
    } catch (error) {
      throw 'Google login failed: $error';
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
