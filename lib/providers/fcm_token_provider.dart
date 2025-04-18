import 'package:flutter/material.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/push_notification.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmTokenProvider with ChangeNotifier {
  final PushNotification _pushNotification = PushNotification();

  Future<void> _requestPermission() async {
    await _pushNotification.requestPermission();
  }

  Future<bool> isPermissionGranted() async {
    return await _pushNotification.isPermissionGranted();
  }

  Future<void> initialize() async {
    if (!(await isPermissionGranted())) {
      await _requestPermission();
    }
    await FlutterNewBadger.removeBadge();
    await _pushNotification.initPushNotifications(
        onTokenUpdated: (newToken) async {
      final session = Supabase.instance.client.auth.currentSession;
      if (newToken != null && session?.accessToken != null) {
        _sendFcmTokenRequest('/api/auth/upsert_fcm', newToken);
      }
    });
  }

  Future<String> getFcm() async {
    try {
      final token = await _pushNotification.getToken();
      if (token != null) {
        return token;
      } else {
        throw Exception("There is no FCM token.");
      }
    } catch (error) {
      throw Exception("Error fetching FCM token: $error");
    }
  }

  Future<Map<String, dynamic>> deleteFcm() async {
    final token = await getFcm();
    final responseData = _sendFcmTokenRequest('/api/auth/logout', token);

    return responseData;
  }

  Future<Map<String, dynamic>> _sendFcmTokenRequest(
    String endpoint,
    String token,
  ) async {
    while (true) {
      try {
        final Map<String, String> headers = {
          'Content-Type': 'application/json'
        };
        final Map<String, String> bodies = {'fcm_token': token};

        final responseData = await apiRequest(
          endpoint,
          ApiType.post,
          headers: headers,
          bodies: bodies,
        );
        return responseData;
      } catch (error) {
        if (error.toString().contains('Invalid or expired JWT')) {
          await Utils.waitForSession();
        } else {
          throw Exception("Error sending FCM token request: $error");
        }
      }
    }
  }
}
