import 'package:flutter/material.dart';
import 'package:msp_app/core/services/background_service.dart';

class NotificationNavigator {
  /// Handle notification tap và navigate đến màn hình tương ứng
  static void handleNotificationTap({
    required String entityType,
    required String entityId,
    required String notificationType,
    Map<String, dynamic>? data,
  }) {
    // Get navigator context
    final context = BackgroundServiceHelper.navigatorKey.currentContext;
    if (context == null) {
      debugPrint('❌ Navigator context is null');
      return;
    }

    debugPrint('🎯 Navigating to: $entityType ($entityId)');

    // Navigate based on entity type
    switch (entityType) {
      case 'project':
        _navigateToProjectDetail(context, entityId);
        break;

      case 'task':
        _navigateToTaskDetail(context, entityId);
        break;

      case 'meeting':
        _navigateToMeetingDetail(context, entityId);
        break;

      case 'notification':
      default:
        _navigateToNotificationList(context);
        break;
    }
  }

  // Navigate to Project Detail
  static void _navigateToProjectDetail(BuildContext context, String projectId) {
    if (projectId.isEmpty) {
      _navigateToNotificationList(context);
      return;
    }

    Navigator.pushNamed(
      context,
      '/project-detail',
      arguments: {'projectId': projectId},
    );
  }

  // Navigate to Task Detail
  static void _navigateToTaskDetail(BuildContext context, String taskId) {
    if (taskId.isEmpty) {
      _navigateToNotificationList(context);
      return;
    }

    Navigator.pushNamed(context, '/task-detail', arguments: {'taskId': taskId});
  }

  // Navigate to Meeting Detail
  static void _navigateToMeetingDetail(BuildContext context, String meetingId) {
    if (meetingId.isEmpty) {
      _navigateToNotificationList(context);
      return;
    }

    Navigator.pushNamed(
      context,
      '/meeting-detail',
      arguments: {'meetingId': meetingId},
    );
  }

  // Navigate to Notification List (fallback)
  static void _navigateToNotificationList(BuildContext context) {
    Navigator.pushNamed(context, '/notifications');
  }
}
