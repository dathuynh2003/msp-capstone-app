import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:msp_app/core/core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../local/user_prefs.dart';
import '../../features/notification/data/models/notification_model.dart';

class SignalRService {
  HubConnection? _connection;
  final StreamController<NotificationModel> _notificationController =
      StreamController<NotificationModel>.broadcast();
  final StreamController<int> _unreadCountController =
      StreamController<int>.broadcast();

  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;
  Stream<int> get unreadCountStream => _unreadCountController.stream;

  /// Initialize and connect to SignalR Hub
  Future<void> connect() async {
    if (_connection != null && isConnected) {
      debugPrint('🔗 [SignalR] Already connected');
      return;
    }

    try {
      // Get access token from SharedPreferences
      final userData = await UserPrefs.getUser();
      final accessToken = userData['accessToken'];

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ [SignalR] No access token found, cannot connect');
        return;
      }

      // SignalR Hub URL - THAY ĐỔI URL NÀY CHO ĐÚNG VỚI BACKEND CỦA BẠN
      // const hubUrl = 'https://msp.audivia.vn/api/v1/notificationHub';
      const hubUrl = '${ApiConfig.apiBaseUrl}/notificationHub';

      debugPrint('🔌 [SignalR] Connecting to $hubUrl');

      // Create connection with JWT token
      _connection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => accessToken,
              // logger: (level, message) => debugPrint('SignalR Log: $message'),
              transport: HttpTransportType.WebSockets,
            ),
          )
          .withAutomaticReconnect(
            retryDelays: [0, 2000, 5000, 10000, 30000], // milliseconds
          )
          .build();

      // Setup event handlers BEFORE connecting
      _setupEventHandlers();

      // Start connection
      await _connection!.start();
      debugPrint('✅ [SignalR] Connected successfully');
    } catch (e) {
      debugPrint('❌ [SignalR] Connection error: $e');
      rethrow;
    }
  }

  /// Setup SignalR event listeners
  void _setupEventHandlers() {
    if (_connection == null) return;

    // Listen for "ReceiveNotification" event from backend
    _connection!.on('ReceiveNotification', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final data = arguments[0] as Map<String, dynamic>;
          final notification = NotificationModel.fromJson(data);

          debugPrint(
            '📩 [SignalR] Received notification: ${notification.title}',
          );
          _notificationController.add(notification);
        } catch (e) {
          debugPrint('❌ [SignalR] Error parsing notification: $e');
        }
      }
    });

    // Listen for "UpdateUnreadCount" event
    _connection!.on('UpdateUnreadCount', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final count = arguments[0] as int;
          debugPrint('🔢 [SignalR] Unread count updated: $count');
          _unreadCountController.add(count);
        } catch (e) {
          debugPrint('❌ [SignalR] Error parsing unread count: $e');
        }
      }
    });

    // Connection state handlers
    _connection!.onclose(({error}) {
      debugPrint('🔌 [SignalR] Connection closed. Error: $error');
    });

    _connection!.onreconnecting(({error}) {
      debugPrint('🔄 [SignalR] Reconnecting... Error: $error');
    });

    _connection!.onreconnected(({connectionId}) {
      debugPrint('✅ [SignalR] Reconnected with ConnectionId: $connectionId');
    });
  }

  /// Mark notification as read (call backend via SignalR)
  Future<void> markNotificationAsRead(String notificationId) async {
    if (!isConnected) {
      debugPrint('⚠️ [SignalR] Not connected, cannot mark as read');
      return;
    }

    try {
      await _connection!.invoke(
        'MarkNotificationAsRead',
        args: [notificationId],
      );
      debugPrint('✓ [SignalR] Marked notification $notificationId as read');
    } catch (e) {
      debugPrint('❌ [SignalR] Error marking notification as read: $e');
    }
  }

  /// Disconnect from SignalR Hub
  Future<void> disconnect() async {
    if (_connection == null) return;

    try {
      await _connection!.stop();
      debugPrint('🔌 [SignalR] Disconnected');
    } catch (e) {
      debugPrint('❌ [SignalR] Error disconnecting: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _notificationController.close();
    _unreadCountController.close();
    disconnect();
  }
}
