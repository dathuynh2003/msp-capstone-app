import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:msp_app/features/notification/data/models/notification_response.dart';
import 'package:msp_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:msp_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:msp_app/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:msp_app/features/notification/domain/usecases/get_user_notifications_usecase.dart';
import 'package:msp_app/features/notification/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:msp_app/features/notification/domain/usecases/mark_as_read_usecase.dart';

// ============================================
// DATA LAYER PROVIDERS
// ============================================

// Remote Datasource Provider
final notificationRemoteDatasourceProvider =
    Provider<NotificationRemoteDatasource>((ref) {
      return NotificationRemoteDatasource();
    });

// Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDatasource = ref.watch(notificationRemoteDatasourceProvider);
  return NotificationRepositoryImpl(remoteDatasource);
});

// ============================================
// DOMAIN LAYER PROVIDERS (USECASES)
// ============================================

// Get User Notifications Usecase
final getUserNotificationsUsecaseProvider =
    Provider<GetUserNotificationsUsecase>((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return GetUserNotificationsUsecase(repository);
    });

// Mark As Read Usecase
final markAsReadUsecaseProvider = Provider<MarkAsReadUsecase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAsReadUsecase(repository);
});

// Mark All As Read Usecase
final markAllAsReadUsecaseProvider = Provider<MarkAllAsReadUsecase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAllAsReadUsecase(repository);
});

// Delete Notification Usecase
final deleteNotificationUsecaseProvider = Provider<DeleteNotificationUsecase>((
  ref,
) {
  final repository = ref.watch(notificationRepositoryProvider);
  return DeleteNotificationUsecase(repository);
});

// ============================================
// PRESENTATION LAYER PROVIDERS
// ============================================

// Notification List Provider (using usecase)
final notificationListProvider =
    FutureProvider.family<List<NotificationResponse>, String>((
      ref,
      userId,
    ) async {
      final usecase = ref.watch(getUserNotificationsUsecaseProvider);
      return await usecase(userId);
    });

// Unread Count Provider
final unreadCountProvider = Provider.family<int, String>((ref, userId) {
  final notificationsAsync = ref.watch(notificationListProvider(userId));

  return notificationsAsync.when(
    data: (notifications) {
      final unreadCount = notifications.where((n) => !n.isRead).length;
      debugPrint('📊 [UnreadCount] User: $userId, Count: $unreadCount');
      return unreadCount;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Notification Actions Provider (for mark as read, delete, etc.)
final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});

// Notification Actions Class
class NotificationActions {
  final Ref ref;

  NotificationActions(this.ref);

  Future<void> markAsRead(String notificationId, String userId) async {
    final usecase = ref.read(markAsReadUsecaseProvider);

    try {
      // ✅ Call usecase and get updated notification
      final updatedNotification = await usecase(notificationId);
      debugPrint(
        '✅ [NotificationActions] Marked as read: ${updatedNotification.id}',
      );

      // Refresh notification list
      ref.invalidate(notificationListProvider(userId));
    } catch (e) {
      debugPrint('❌ [NotificationActions] Error marking as read: $e');
      rethrow;
    }
  }

  Future<String> markAllAsRead(String userId) async {
    final usecase = ref.read(markAllAsReadUsecaseProvider);

    try {
      final message = await usecase(userId);
      debugPrint('✅ [NotificationActions] $message');

      // Refresh notification list
      ref.invalidate(notificationListProvider(userId));

      return message;
    } catch (e) {
      debugPrint('❌ [NotificationActions] Error marking all as read: $e');
      rethrow;
    }
  }

  Future<bool> deleteNotification(String notificationId, String userId) async {
    final usecase = ref.read(deleteNotificationUsecaseProvider);

    try {
      final success = await usecase(notificationId);

      if (success) {
        debugPrint(
          '✅ [NotificationActions] Deleted notification: $notificationId',
        );

        // Refresh notification list
        ref.invalidate(notificationListProvider(userId));
      }

      return success;
    } catch (e) {
      debugPrint('❌ [NotificationActions] Error deleting notification: $e');
      rethrow;
    }
  }
}
