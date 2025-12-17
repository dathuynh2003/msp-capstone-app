import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/notification/presentation/providers/notification_provider.dart';
import 'package:msp_app/features/notification/presentation/widgets/notification_item_card.dart';
import 'package:msp_app/features/notification/presentation/utils/notification_navigation_handler.dart';

const Color orangeDeep = Color(0xFFFFA463);
const Color pastelPeach = Color(0xFFFFD7BA);
const Color pastelCream = Color(0xFFFFF5ED);

class NotificationListPage extends ConsumerWidget {
  final String userId;

  const NotificationListPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider(userId));

    return Scaffold(
      backgroundColor: pastelCream,
      appBar: AppBar(
        backgroundColor: pastelPeach,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFFFF7716),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFF7716)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Color(0xFFFF7716)),
            tooltip: 'Mark all as read',
            onPressed: () => _handleMarkAllAsRead(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(notificationListProvider(userId));
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: orangeDeep,
        child: notificationsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            final unreadNotifications = notifications
                .where((n) => !n.isRead)
                .toList();
            final readNotifications = notifications
                .where((n) => n.isRead)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (unreadNotifications.isNotEmpty) ...[
                  _buildSectionHeader('Unread', unreadNotifications.length),
                  const SizedBox(height: 12),
                  ...unreadNotifications.map((notification) {
                    return NotificationItemCard(
                      notification: notification,
                      onTap: () =>
                          _handleNotificationTap(context, ref, notification),
                      onDelete: () =>
                          _handleDelete(context, ref, notification.id),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
                if (readNotifications.isNotEmpty) ...[
                  _buildSectionHeader('Earlier', readNotifications.length),
                  const SizedBox(height: 12),
                  ...readNotifications.map((notification) {
                    return NotificationItemCard(
                      notification: notification,
                      onTap: () =>
                          _handleNotificationTap(context, ref, notification),
                      onDelete: () =>
                          _handleDelete(context, ref, notification.id),
                    );
                  }),
                ],
              ],
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator(color: orangeDeep)),
          error: (error, stack) => _buildErrorState(ref),
        ),
      ),
    );
  }

  // ✅ UPDATED: Return Future<bool>
  Future<bool> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    String notificationId,
  ) async {
    final notificationActions = ref.read(notificationActionsProvider);

    try {
      debugPrint('🗑️ [NotificationList] Deleting: $notificationId');

      final success = await notificationActions.deleteNotification(
        notificationId,
        userId,
      );

      if (success) {
        debugPrint('✅ [NotificationList] Delete successful');

        // ✅ Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification deleted'),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
      }

      return success; // ✅ Return success status
    } catch (e) {
      debugPrint('❌ [NotificationList] Delete error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }

      return false; // ✅ Return false on error
    }
  }

  Future<void> _handleMarkAllAsRead(BuildContext context, WidgetRef ref) async {
    final notificationActions = ref.read(notificationActionsProvider);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const Center(child: CircularProgressIndicator(color: orangeDeep)),
      );

      final message = await notificationActions.markAllAsRead(userId);

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    notification,
  ) async {
    final notificationActions = ref.read(notificationActionsProvider);

    await NotificationNavigationHandler.handleNotificationTap(
      context: context,
      notification: notification,
      markAsRead: notificationActions.markAsRead,
      userId: userId,
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: pastelPeach,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7716),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: pastelPeach,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 80,
              color: Color(0xFFFF9966),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something new arrives',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(notificationListProvider(userId));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: pastelPeach,
              foregroundColor: const Color(0xFFFF7716),
            ),
          ),
        ],
      ),
    );
  }
}
