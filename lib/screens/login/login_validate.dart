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
      String? accessToken, String? idToken) async {
    if (accessToken == null || idToken == null) {
      throw 'Access Token or ID Token is missing.';
    }
  }
}
