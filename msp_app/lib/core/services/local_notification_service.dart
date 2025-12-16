import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

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
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // const iosSettings = DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );

    const initSettings = InitializationSettings(
      android: androidSettings,
      // iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
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
      await androidPlugin.requestNotificationsPermission();
    }

    // final iosPlugin = _notifications
    //     .resolvePlatformSpecificImplementation<
    //       IOSFlutterLocalNotificationsPlugin
    //     >();

    // if (iosPlugin != null) {
    //   await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    // }
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
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 [LocalNotification] Tapped: ${response.payload}');

    // TODO: Navigate to notification detail page
    // Parse payload và navigate đến màn hình tương ứng
    if (response.payload != null) {
      // Example: payload = "task:abc123" hoặc "meeting:xyz789"
      final parts = response.payload!.split(':');
      if (parts.length == 2) {
        final type = parts[0];
        final entityId = parts[1];

        // Navigate based on type
        // navigatorKey.currentState?.pushNamed('/detail', arguments: entityId);
      }
    }
  }

  /// Cancel notification
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
