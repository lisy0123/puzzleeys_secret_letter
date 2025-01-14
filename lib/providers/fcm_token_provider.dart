import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/push_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmTokenProvider with ChangeNotifier {
  final PushNotification _pushNotification = PushNotification();

  Future<void> requestPermission() async {
    await _pushNotification.requestPermission();
  }

  Future<bool> isPermissionGranted() async {
    return await _pushNotification.isPermissionGranted();
  }

  Future<void> initialize() async {
    if (!(await isPermissionGranted())) {
      await requestPermission();
    }
    await _pushNotification.initPushNotifications(
        onTokenUpdated: (newToken) async {
      final session = Supabase.instance.client.auth.currentSession;
      if (newToken != null && session?.accessToken != null) {
        await _sendFcmTokenRequest('/api/auth/upsert_fcm', newToken);
      }
    });
  }

  Future<String?> getFcm() async {
    try {
      return await _pushNotification.getToken();
    } catch (error) {
      throw "Error fetching FCM token: $error";
    }
  }

  Future<void> deleteFcm() async {
    final token = await getFcm();
    if (token != null) {
      _sendFcmTokenRequest('/api/auth/logout', token);
    } else {
      throw "There is no FCM token.";
    }
  }

  Future<void> _sendFcmTokenRequest(String endpoint, String token) async {
    try {
      await apiRequest(
        endpoint,
        ApiType.post,
        headers: {'Content-Type': 'application/json'},
        bodies: {'fcm_token': token},
      );
    } catch (error) {
      throw "Error sending FCM token request: $error";
    }
  }
}
