import 'package:msp_app/features/notification/data/models/notification_response.dart';

abstract class NotificationRepository {
  Future<List<NotificationResponse>> getUserNotifications(String userId);
  Future<NotificationResponse> markAsRead(String notificationId);
  Future<String> markAllAsRead(String userId);
  Future<bool> deleteNotification(String notificationId);
}
