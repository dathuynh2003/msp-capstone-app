import 'package:msp_app/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:msp_app/features/notification/data/models/notification_response.dart';
import 'package:msp_app/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<NotificationResponse>> getUserNotifications(String userId) {
    return remoteDatasource.getUserNotifications(userId);
  }

  @override
  Future<NotificationResponse> markAsRead(String notificationId) {
    return remoteDatasource.markAsRead(notificationId);
  }

  @override
  Future<String> markAllAsRead(String userId) {
    return remoteDatasource.markAllAsRead(userId);
  }

  @override
  Future<bool> deleteNotification(String notificationId) {
    return remoteDatasource.deleteNotification(notificationId);
  }
}
