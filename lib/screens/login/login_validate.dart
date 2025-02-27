import 'package:google_sign_in/google_sign_in.dart';

class LoginValidate {
  static void validateClientIds(String? webClientId, String? iosClientId) {
    if (webClientId == null || iosClientId == null) {
      throw 'Missing client ID for either web or iOS in environment variables.';
    }
  }

  static void validateGoogleUser(GoogleSignInAccount? googleUser) {
    if (googleUser == null) {
      throw 'Google Sign-In failed or was canceled.';
    }
  }

  static Future<void> validateTokens(
      String? idToken, String? accessToken, String? nonce) async {
    if (idToken == null) {
      throw 'ID Token is missing.';
    }
    if (accessToken == null && nonce == null) {
      throw 'Access Token or Nonce is missing.';
    }
  }
}
