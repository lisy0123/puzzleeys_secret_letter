import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
AndroidNotificationChannel? channel;
const String notificationIcon = '@mipmap/ic_launcher';

class FPPushNotificationService {
  // 싱글톤 패턴을 사용하여 FPPushNotificationService 인스턴스를 하나만 유지
  static final FPPushNotificationService _instance =
  FPPushNotificationService._internal();

  // 싱글톤 인스턴스를 반환하는 팩토리 생성자
  factory FPPushNotificationService() => _instance;

  FPPushNotificationService._internal();

  // 푸시 알림 초기화 (로컬 알림, 안드로이드 채널, Firebase 메시징 초기화)
  Future<void> initialize() async {
    try {
      await Future.wait([
        _initLocalNotifications(),
        _initAndroidChannel(),
        _initFirebaseMessaging(),
      ]);
    } catch (error) {
      debugPrint("Error during notification initialization: $error");
    }
  }

  // 로컬 알림 초기화 (안드로이드 및 iOS 설정)
  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(notificationIcon);
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(settings);
    } catch (error) {
      debugPrint("Error during local notifications initialization: $error");
    }
  }

  // 안드로이드 알림 채널 초기화
  Future<void> _initAndroidChannel() async {
    if (channel == null) {
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        final packageName = packageInfo.packageName;

        channel = AndroidNotificationChannel(
          packageName,
          'Notifications',
          importance: Importance.high,
        );

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel!);
      } catch (error) {
        debugPrint(
          "Error during Android notification channel initialization: $error",
        );
      }
    }
  }

  // Firebase 메시징 초기화 (배경 및 포그라운드 메시지 처리)
  Future<void> _initFirebaseMessaging() async {
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessage.listen(_messageHandler);
  }

  // 푸시 메시지를 처리하는 핸들러 (알림 또는 데이터를 처리)
  static Future<void> _messageHandler(RemoteMessage message) async {
    if (message.notification != null) {
      await _showNotification(message.notification);
    } else if (message.data.isNotEmpty) {
      await _showNotificationFromData(message.data);
    } else {
      debugPrint("Received message does not contain notification or data.");
    }
  }

  // 데이터 메시지에서 알림 정보를 추출하여 로컬 알림 표시
  static Future<void> _showNotificationFromData(
      Map<String, dynamic> data) async {
    String? title = data['title'];
    String? body = data['body'];

    if (title != null && body != null) {
      await _showNotificationBody(
        DateTime.now().millisecondsSinceEpoch,
        title,
        body,
      );
    } else {
      debugPrint("Message data does not contain title or body.");
    }
  }

  // 알림 권한을 요청하는 메서드
  Future<void> requestPermission() async {
    final permissionResult = await _requestNotificationPermission();
    if (permissionResult != PermissionStatus.granted) {
      debugPrint("${Platform.operatingSystem} notification permission denied");
    }
  }

  // 알림 권한을 요청하는 실제 메서드 (안드로이드 및 iOS)
  Future<PermissionStatus> _requestNotificationPermission() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await Permission.notification.request();
        return status;
      } else {
        return PermissionStatus.denied;
      }
    } catch (error) {
      debugPrint("Error requesting notification permission: $error");
      return PermissionStatus.denied;
    }
  }

  // 알림 권한 상태 확인
  Future<bool> isPermissionGranted() async {
    final status = await Permission.notification.status;
    return status == PermissionStatus.granted;
  }

  // Firebase 메시징에서 FCM 토큰을 가져오는 메서드
  Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (error) {
      debugPrint("Error getting FCM token: $error");
      return null;
    }
  }

  // 푸시 알림 초기화 및 FCM 토큰 처리
  Future<void> initPushNotifications(
      {required Function(String? fcmToken) onTokenUpdated}) async {
    await requestPermission();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await getToken();
    onTokenUpdated(token);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      onTokenUpdated(newToken);
    });
  }

  // 로컬 알림을 표시하는 메서드
  Future<void> showLocalNotification({
    int id = 0,
    required String? title,
    required String? body,
  }) async {
    await _showNotificationBody(id, title, body);
  }

  // 수신된 메시지를 처리하여 로컬 알림을 표시하는 메서드
  static Future<void> _showNotification(
      RemoteNotification? notification) async {
    if (notification != null) {
      await _showNotificationBody(
        notification.hashCode,
        notification.title,
        notification.body,
      );
    } else {
      debugPrint("Notification payload is null.");
    }
  }

  // 로컬 알림의 실제 표시를 처리하는 메서드
  static Future<void> _showNotificationBody(
      int id,
      String? title,
      String? body,
      ) async {
    if (channel == null) {
      debugPrint(
        "Notification channel is not initialized. Please check the initialization process.",
      );
      return;
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel!.id,
        channel!.name,
        icon: notificationIcon,
        importance: Importance.high,
      ),
    );
    try {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
      );
    } catch (error) {
      debugPrint("Error displaying notification: $error");
    }
  }
}
