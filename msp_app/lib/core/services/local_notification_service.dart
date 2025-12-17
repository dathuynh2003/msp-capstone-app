import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../navigation/notification_navigator.dart';
import 'package:msp_app/core/services/background_service.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize local notifications
  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('⚠️ [LocalNotification] Already initialized');
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          _onNotificationTapped, // ✅ CRITICAL
    );

    // Request permission (Android 13+)
    await _requestPermissions();

    _initialized = true;
    debugPrint('✅ [LocalNotification] Initialized');
  }

  /// Request notification permissions (Android 13+)
  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      debugPrint('🔔 [LocalNotification] Permission granted: $granted');
    }
  }

  /// Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'msp_notifications', // Channel ID
      'MSP Notifications', // Channel name
      channelDescription: 'Notifications from MSP Project Management',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
    debugPrint('📬 [LocalNotification] Showed: $title');
    if (payload != null) {
      debugPrint('📦 [LocalNotification] Payload: $payload');
    }
  }

  /// Handle notification tap (FOREGROUND & BACKGROUND)
  @pragma('vm:entry-point')
  static void _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;

    debugPrint('');
    debugPrint('========================================');
    debugPrint('🔔 [LocalNotification] TAPPED');
    debugPrint('🔔 [LocalNotification] Action: ${response.actionId}');
    debugPrint('🔔 [LocalNotification] Payload: $payload');
    debugPrint('========================================');

    if (payload == null || payload.isEmpty) {
      debugPrint('⚠️ [LocalNotification] Empty payload - ignoring');
      debugPrint('========================================');
      debugPrint('');
      return;
    }

    try {
      // Parse JSON payload
      final data = jsonDecode(payload) as Map<String, dynamic>;

      final entityType = data['entityType'] as String?;
      final entityId = data['entityId'] as String?;
      final notificationType = data['notificationType'] as String?;
      final extraData = data['data'] as Map<String, dynamic>?;

      debugPrint('📦 [LocalNotification] Parsed:');
      debugPrint('   - entityType: $entityType');
      debugPrint('   - entityId: $entityId');
      debugPrint('   - notificationType: $notificationType');
      debugPrint('   - extraData: $extraData');

      if (entityType == null || entityId == null) {
        debugPrint('❌ [LocalNotification] Missing entityType or entityId');
        debugPrint('========================================');
        debugPrint('');
        return;
      }

      // Wait for app to be ready
      debugPrint('⏳ [LocalNotification] Waiting 500ms for app...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if context is available
      var context = BackgroundServiceHelper.navigatorKey.currentContext;

      if (context == null) {
        debugPrint('⚠️ [LocalNotification] Context null - retrying in 1s...');
        await Future.delayed(const Duration(seconds: 1));
        context = BackgroundServiceHelper.navigatorKey.currentContext;

        if (context == null) {
          debugPrint('❌ [LocalNotification] Context still null - giving up');
          debugPrint('========================================');
          debugPrint('');
          return;
        }
      }

      debugPrint('✅ [LocalNotification] Context ready - navigating...');

      // Navigate using NotificationNavigator
      NotificationNavigator.handleNotificationTap(
        entityType: entityType,
        entityId: entityId,
        notificationType: notificationType ?? 'unknown',
        data: extraData,
      );

      debugPrint('✅ [LocalNotification] Navigation triggered');
      debugPrint('========================================');
      debugPrint('');
    } catch (e, stack) {
      debugPrint('❌ [LocalNotification] Error: $e');
      debugPrint('Stack: $stack');
      debugPrint('========================================');
      debugPrint('');
    }
  }

  /// Cancel notification
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
    debugPrint('🗑️ [LocalNotification] Cancelled: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    debugPrint('🗑️ [LocalNotification] Cancelled all');
  }
}
