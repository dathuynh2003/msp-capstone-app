import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:msp_app/core/routes/app_routes.dart';
import 'package:msp_app/features/notification/data/models/notification_response.dart';
import 'package:msp_app/features/notification/presentation/utils/notification_helper.dart';

class NotificationNavigationHandler {
  static Future<void> handleNotificationTap({
    required BuildContext context,
    required NotificationResponse notification,
    required Function(String notificationId, String userId) markAsRead,
    required String userId,
  }) async {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('🔔 [NotificationNav] START HANDLING TAP');
    debugPrint('🔔 [NotificationNav] Notification ID: ${notification.id}');
    debugPrint('🔔 [NotificationNav] Type: ${notification.type}');
    debugPrint('🔔 [NotificationNav] EntityId: ${notification.entityId}');
    debugPrint('🔔 [NotificationNav] Data: ${notification.data}');
    debugPrint('🔔 [NotificationNav] IsRead: ${notification.isRead}');
    debugPrint('========================================');

    final notifType = NotificationHelper.getNotificationType(notification.type);
    debugPrint('🔍 [NotificationNav] Parsed Type: $notifType');

    // Mark as read first
    try {
      if (!notification.isRead) {
        debugPrint('📝 [NotificationNav] Marking as read...');
        await markAsRead(notification.id, userId);
        debugPrint('✅ [NotificationNav] Marked as read successfully');
      } else {
        debugPrint('✓ [NotificationNav] Already read, skipping mark');
      }
    } catch (e) {
      debugPrint('❌ [NotificationNav] Error marking as read: $e');
      // Continue with navigation
    }

    if (!context.mounted) {
      debugPrint('❌ [NotificationNav] Context not mounted, aborting');
      return;
    }

    // Navigate based on type
    debugPrint('🚀 [NotificationNav] Starting navigation for type: $notifType');

    switch (notifType) {
      case NotificationType.taskAssignment:
        debugPrint('→ [NotificationNav] Route: TASK ASSIGNMENT');
        _navigateToTask(context, notification);
        break;

      case NotificationType.taskUpdate:
        debugPrint('→ [NotificationNav] Route: TASK UPDATE');
        _navigateToTask(context, notification);
        break;

      case NotificationType.projectUpdate:
        debugPrint('→ [NotificationNav] Route: PROJECT UPDATE');
        _navigateToProject(context, notification);
        break;

      case NotificationType.meetingReminder:
        debugPrint('→ [NotificationNav] Route: MEETING REMINDER');
        _navigateToMeeting(context, notification);
        break;

      default:
        debugPrint(
          'ℹ️ [NotificationNav] No navigation needed for type: $notifType',
        );
        _showSnackbar(context, 'Notification marked as read');
        break;
    }

    debugPrint('🏁 [NotificationNav] FINISHED HANDLING TAP');
    debugPrint('========================================');
  }

  static void _navigateToTask(
    BuildContext context,
    NotificationResponse notification,
  ) {
    debugPrint('');
    debugPrint('>>> [NavigateToTask] START');

    // ✅ TRY ENTITYID FIRST (should be taskId)
    String? taskId = notification.entityId;
    debugPrint('>>> [NavigateToTask] EntityId (TaskId): $taskId');

    // ✅ If entityId is null, try to parse from data
    if (taskId == null || taskId.isEmpty) {
      debugPrint('>>> [NavigateToTask] EntityId is null, parsing from data...');

      if (notification.data != null && notification.data!.isNotEmpty) {
        try {
          final dataMap = _parseJsonString(notification.data!);
          debugPrint('>>> [NavigateToTask] Parsed dataMap: $dataMap');

          // Try different key formats
          taskId =
              dataMap['TaskId']?.toString() ??
              dataMap['taskId']?.toString() ??
              dataMap['task_id']?.toString();

          debugPrint(
            '>>> [NavigateToTask] Extracted taskId from data: $taskId',
          );
        } catch (e) {
          debugPrint('❌ [NavigateToTask] Error parsing data: $e');
        }
      }
    }

    if (taskId == null || taskId.isEmpty) {
      debugPrint('❌ [NavigateToTask] TaskId is null or empty!');
      _showSnackbar(context, 'Task information not found');
      return;
    }

    // ✅ Parse projectId from data
    String? projectId;
    debugPrint('>>> [NavigateToTask] Data field: ${notification.data}');

    try {
      if (notification.data != null && notification.data!.isNotEmpty) {
        debugPrint('>>> [NavigateToTask] Attempting to parse projectId...');
        final dataMap = _parseJsonString(notification.data!);
        debugPrint('>>> [NavigateToTask] Parsed dataMap: $dataMap');

        // Try different key formats
        projectId =
            dataMap['ProjectId']?.toString() ??
            dataMap['projectId']?.toString() ??
            dataMap['project_id']?.toString();

        debugPrint('>>> [NavigateToTask] Extracted projectId: $projectId');
      } else {
        debugPrint('⚠️ [NavigateToTask] Data is null or empty');
      }
    } catch (e) {
      debugPrint('❌ [NavigateToTask] Error parsing data: $e');
    }

    if (projectId == null || projectId.isEmpty) {
      debugPrint('❌ [NavigateToTask] ProjectId not found in data!');
      _showSnackbar(context, 'Project information not found');
      return;
    }

    debugPrint('✅ [NavigateToTask] Ready to navigate!');
    debugPrint('>>> ProjectId: $projectId');
    debugPrint('>>> TaskId: $taskId');
    debugPrint('>>> Route: ${AppRoutes.projectDetail}');

    try {
      Navigator.of(context).pushNamed(
        AppRoutes.projectDetail,
        arguments: {'projectId': projectId, 'highlightTaskId': taskId},
      );
      debugPrint('✅ [NavigateToTask] Navigation called successfully!');
    } catch (e) {
      debugPrint('❌ [NavigateToTask] Navigation error: $e');
      _showSnackbar(context, 'Error navigating to task: $e');
    }

    debugPrint('>>> [NavigateToTask] END');
  }

  static void _navigateToProject(
    BuildContext context,
    NotificationResponse notification,
  ) {
    debugPrint('');
    debugPrint('>>> [NavigateToProject] START');

    // ✅ TRY ENTITYID FIRST, THEN PARSE FROM DATA
    String? projectId = notification.entityId;
    debugPrint('>>> [NavigateToProject] EntityId: $projectId');

    // ✅ If entityId is null, try to parse from data
    if (projectId == null || projectId.isEmpty) {
      debugPrint(
        '>>> [NavigateToProject] EntityId is null, parsing from data...',
      );

      if (notification.data != null && notification.data!.isNotEmpty) {
        try {
          final dataMap = _parseJsonString(notification.data!);
          debugPrint('>>> [NavigateToProject] Parsed dataMap: $dataMap');

          // Try different key formats: ProjectId, projectId, project_id
          projectId =
              dataMap['ProjectId']?.toString() ??
              dataMap['projectId']?.toString() ??
              dataMap['project_id']?.toString();

          debugPrint(
            '>>> [NavigateToProject] Extracted projectId from data: $projectId',
          );
        } catch (e) {
          debugPrint('❌ [NavigateToProject] Error parsing data: $e');
        }
      }
    }

    if (projectId == null || projectId.isEmpty) {
      debugPrint('❌ [NavigateToProject] ProjectId still null after parsing!');
      _showSnackbar(context, 'Project information not found');
      return;
    }

    debugPrint('✅ [NavigateToProject] Ready to navigate!');
    debugPrint('>>> ProjectId: $projectId');
    debugPrint('>>> Route: ${AppRoutes.projectDetail}');

    try {
      Navigator.of(
        context,
      ).pushNamed(AppRoutes.projectDetail, arguments: {'projectId': projectId});
      debugPrint('✅ [NavigateToProject] Navigation called successfully!');
    } catch (e) {
      debugPrint('❌ [NavigateToProject] Navigation error: $e');
      _showSnackbar(context, 'Error navigating to project: $e');
    }

    debugPrint('>>> [NavigateToProject] END');
  }

  static void _navigateToMeeting(
    BuildContext context,
    NotificationResponse notification,
  ) {
    debugPrint('');
    debugPrint('>>> [NavigateToMeeting] START');

    final meetingId = notification.entityId;
    debugPrint('>>> [NavigateToMeeting] MeetingId: $meetingId');

    if (meetingId == null || meetingId.isEmpty) {
      debugPrint('❌ [NavigateToMeeting] MeetingId is null or empty!');
      _showSnackbar(context, 'Meeting information not found');
      return;
    }

    debugPrint('✅ [NavigateToMeeting] Ready to navigate!');
    debugPrint('>>> MeetingId: $meetingId');

    try {
      // TODO: Update with actual meeting route
      Navigator.of(
        context,
      ).pushNamed('/meeting-detail', arguments: {'meetingId': meetingId});
      debugPrint('✅ [NavigateToMeeting] Navigation called successfully!');
    } catch (e) {
      debugPrint('❌ [NavigateToMeeting] Navigation error: $e');
      _showSnackbar(context, 'Meeting detail not implemented yet');
    }

    debugPrint('>>> [NavigateToMeeting] END');
  }

  static Map<String, dynamic> _parseJsonString(String jsonString) {
    debugPrint('>>> [ParseJSON] Input: $jsonString');
    debugPrint('>>> [ParseJSON] Input length: ${jsonString.length}');

    try {
      final trimmed = jsonString.trim();
      debugPrint('>>> [ParseJSON] Trimmed: $trimmed');

      if (trimmed.isEmpty) {
        debugPrint('⚠️ [ParseJSON] Empty string after trim');
        return {};
      }

      final decoded = jsonDecode(trimmed);
      debugPrint('>>> [ParseJSON] Decoded type: ${decoded.runtimeType}');
      debugPrint('>>> [ParseJSON] Decoded value: $decoded');

      if (decoded is Map<String, dynamic>) {
        debugPrint('✅ [ParseJSON] Success! Keys: ${decoded.keys}');
        return decoded;
      }

      debugPrint('⚠️ [ParseJSON] Not a Map, got: ${decoded.runtimeType}');
      return {};
    } catch (e) {
      debugPrint('❌ [ParseJSON] Parse error: $e');
      return {};
    }
  }

  static void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFFFF9966),
      ),
    );
  }
}
