import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:msp_app/core/core.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import 'package:msp_app/core/navigation/notification_navigator.dart';
import 'package:msp_app/core/services/local_notification_service.dart';

// Top-level function cho background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
  debugPrint('📦 Data: ${message.data}');
  // Xử lý notification ở background
}

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Initialize FCM
  Future<void> initialize() async {
    try {
      // Request permission (iOS sẽ hiện popup, Android auto grant từ API 33+)
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');

        // Get FCM token
        _fcmToken = await _firebaseMessaging.getToken();
        debugPrint('FCM Token: $_fcmToken');

        // Listen to token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          _fcmToken = newToken;
          debugPrint('FCM Token refreshed: $newToken');
          sendTokenToBackend();
        });

        // Setup message handlers
        _setupMessageHandlers();

        // Setup background handler
        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    } catch (e) {
      debugPrint('FCM initialization error: $e');
    }
  }

  // Setup message handlers
  void _setupMessageHandlers() {
    // 1. Handle notification tap khi app đã tắt (terminated)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('🚀 App opened from terminated state');
        // Delay để đợi app init xong
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleNotificationTap(message);
        });
      }
    });

    // 2. Handle notification tap khi app đang background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('🚀 App opened from background');
      _handleNotificationTap(message);
    });

    // 3. Handle message khi app đang foreground
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
        '📨 [FCM Foreground] Received: ${message.notification?.title}',
      );
      if (message.notification != null) {
        // Show local notification
        _localNotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification!.title ?? 'Thông báo mới',
          body: message.notification!.body ?? '',
          payload: message.data['entityId'],
        );
      }
    });
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('👆 Notification tapped');
    debugPrint('Data: ${message.data}');

    try {
      final data = message.data;
      final entityType = data['entityType'] ?? '';
      final entityId = data['entityId'] ?? '';
      final notificationType = data['type'] ?? '';

      debugPrint('🎯 Navigate to: $entityType with ID: $entityId');

      // Delegate navigation
      NotificationNavigator.handleNotificationTap(
        entityType: entityType,
        entityId: entityId,
        notificationType: notificationType,
        data: data,
      );
    } catch (e) {
      debugPrint('❌ Error handling notification tap: $e');
    }
  }

  // Send FCM token to backend
  Future<bool> sendTokenToBackend() async {
    if (_fcmToken == null || _fcmToken!.isEmpty) {
      debugPrint('⚠️ [FCM] No token to send');
      return false;
    }

    try {
      final userData = await UserPrefs.getUser();
      final accessToken = userData['accessToken'];

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ [FCM] No access token, cannot send FCM token');
        return false;
      }

      final url = Uri.parse(
        '${ApiConfig.apiBaseUrl}/notification/register-fcm-token',
      );

      debugPrint('📤 [FCM] Sending token to: $url');

      final response = await HttpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'fcmToken': _fcmToken,
          'platform': 'Android',
          'deviceId': null,
          'deviceName': null,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [FCM] Token sent successfully');
        return true;
      } else {
        debugPrint('❌ [FCM] Failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [FCM] Error sending token: $e');
      return false;
    }
  }

  // Deactivate FCM token Khi logout
  Future<bool> deactivateToken() async {
    if (_fcmToken == null || _fcmToken!.isEmpty) {
      debugPrint('⚠️ [FCM] No token to deactivate');
      return false;
    }

    try {
      final userData = await UserPrefs.getUser();
      final accessToken = userData['accessToken'];

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ [FCM] No access token, cannot deactivate');
        return false;
      }

      final url = Uri.parse(
        '${ApiConfig.apiBaseUrl}/notification/deactivate-fcm-token',
      );

      debugPrint('📤 [FCM] Deactivating token');

      final response = await HttpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'fcmToken': _fcmToken}),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [FCM] Token deactivated');
        return true;
      } else {
        debugPrint('❌ [FCM] Deactivate failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [FCM] Error deactivating: $e');
      return false;
    }
  }

  // Subscribe to topic (optional)
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}
