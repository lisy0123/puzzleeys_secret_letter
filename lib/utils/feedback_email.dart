import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:puzzleeys_secret_letter/utils/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart';
import 'dart:ui' as ui;

class FeedbackEmail {
  static String _appVersion = '';
  static String _osVersion = '';
  static String _deviceInfo = '';
  static String _userId = '';

  static Future<void> initialize() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String deviceInfo = '';
    String osVersion = '';
    String? userId;

    if (TargetPlatform.android.toString() == 'TargetPlatform.android') {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceInfo = '${androidInfo.manufacturer} ${androidInfo.model}';
      osVersion = 'Android ${androidInfo.version.release}';
    } else if (TargetPlatform.iOS.toString() == 'TargetPlatform.iOS') {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceInfo = '${iosInfo.name} ${iosInfo.model}';
      osVersion = 'iOS ${iosInfo.systemVersion}';
    }

    final String appVersion = await Utils.getAppVersion();

    userId = await SecureStorageUtils.get('userId');
    if (userId == null) {
      (userId, _) = await UserRequest.reloadUserData();
    }

    _appVersion = appVersion;
    _osVersion = osVersion;
    _deviceInfo = deviceInfo;
    _userId = userId;
  }

  static Future<void> send() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: CustomStrings.email,
      query: _encodeQueryParameters(<String, String>{
        'subject': '[PUZZLEEY][${_osVersion.split(' ')[0]}] Feedback',
        'body': '''
여기에 내용을 입력해주세요.
-----------------------------------------------------------------
아래 정보는 여러분의 소중한 의견을 원활하게 해결해 드리기 위한 정보예요.
삭제하지 말아 주세요.

- App Version: $_appVersion
- OS Version: $_osVersion
- Device Info: $_deviceInfo
- Language: ${ui.PlatformDispatcher.instance.locale.languageCode}
- User Id: $_userId
        '''
      }),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('Can not send the feedback email.');
    }
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
