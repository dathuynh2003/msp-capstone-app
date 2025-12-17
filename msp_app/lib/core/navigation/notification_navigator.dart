import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/services/background_service.dart';
import 'package:msp_app/features/project/presentation/providers/project_detail_provider.dart';
import 'package:msp_app/features/project/domain/params/project_detail_params.dart';
import 'package:msp_app/features/home/presentation/providers/user_provider.dart';
import '../routes/app_routes.dart';

class NotificationNavigator {
  /// Handle notification tap và navigate đến màn hình tương ứng
  static void handleNotificationTap({
    required String entityType,
    required String entityId,
    required String notificationType,
    Map<String, dynamic>? data,
  }) {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('🎯 [NotificationNavigator] START');
    debugPrint('🎯 entityType: $entityType');
    debugPrint('🎯 entityId: $entityId');
    debugPrint('🎯 notificationType: $notificationType');
    debugPrint('📦 data: $data');
    debugPrint('========================================');

    final context = BackgroundServiceHelper.navigatorKey.currentContext;
    if (context == null) {
      debugPrint('❌ [NotificationNavigator] Context is null - cannot navigate');
      debugPrint('========================================');
      debugPrint('');
      return;
    }

    debugPrint('✅ [NotificationNavigator] Context available');

    switch (entityType.toLowerCase()) {
      case 'task':
        _navigateToTask(context, entityId, data);
        break;

      case 'project':
        _navigateToProject(context, entityId, data);
        break;

      case 'meeting':
        _navigateToMeeting(context, entityId, data);
        break;

      case 'notification':
      default:
        debugPrint(
          '⚠️ [NotificationNavigator] Unknown entityType: $entityType',
        );
        _navigateToNotificationList(context);
        break;
    }

    debugPrint('========================================');
    debugPrint('');
  }

  /// ✅ HELPER: Refresh project data before navigation
  static Future<bool> _refreshProjectData(
    BuildContext context,
    String projectId,
  ) async {
    try {
      debugPrint('');
      debugPrint('🔄 [NotificationNavigator] Refreshing project data...');
      debugPrint('🔄 projectId: $projectId');

      // Get ProviderContainer from context
      final container = ProviderScope.containerOf(context);

      // Get user data
      final user = container.read(userProvider);
      final userId = user.userId;

      debugPrint('🔄 userId: $userId');

      // Create params
      final params = ProjectDetailParams(projectId, userId);

      debugPrint('🔄 Invalidating projectDetailProvider...');

      // Invalidate provider to force refresh
      container.invalidate(projectDetailProvider(params));

      debugPrint('✅ Provider invalidated');

      // Wait a bit to let provider refresh
      debugPrint('⏳ Waiting 400ms for data to refresh...');
      await Future.delayed(const Duration(milliseconds: 400));

      debugPrint('✅ [NotificationNavigator] Project data refreshed');
      debugPrint('');
      return true;
    } catch (e, stack) {
      debugPrint('❌ [NotificationNavigator] Error refreshing data: $e');
      debugPrint('Stack: $stack');
      debugPrint('');
      return false;
    }
  }

  /// Navigate to Task (via Project Detail + highlight task)
  static void _navigateToTask(
    BuildContext context,
    String taskId,
    Map<String, dynamic>? data,
  ) async {
    debugPrint('📋 [NotificationNavigator] _navigateToTask called');
    debugPrint('   - taskId: $taskId');
    debugPrint('   - data: $data');

    final projectId = data?['projectId'] as String?;

    if (projectId == null || projectId.isEmpty) {
      debugPrint('❌ [NotificationNavigator] Missing projectId for task');
      _navigateToNotificationList(context);
      return;
    }

    debugPrint(
      '📂 [NotificationNavigator] Preparing navigation to project detail',
    );
    debugPrint('   - projectId: $projectId');
    debugPrint('   - highlightTaskId: $taskId');
    debugPrint('   - route: ${AppRoutes.projectDetail}');

    // ✅ Refresh project data before navigation
    final refreshSuccess = await _refreshProjectData(context, projectId);

    if (!refreshSuccess) {
      debugPrint(
        '⚠️ [NotificationNavigator] Refresh failed, but continuing...',
      );
    }

    // Prepare arguments
    final arguments = {
      'projectId': projectId,
      'highlightTaskId': taskId,
      'taskName': data?['taskName'],
      'projectName': data?['projectName'],
    };

    debugPrint('📦 [NotificationNavigator] Arguments: $arguments');

    // Navigate
    try {
      Navigator.pushNamed(
        context,
        AppRoutes.projectDetail,
        arguments: arguments,
      );
      debugPrint('✅ [NotificationNavigator] pushNamed executed');
    } catch (e, stack) {
      debugPrint('❌ [NotificationNavigator] Navigation error: $e');
      debugPrint('Stack: $stack');
    }
  }

  /// Navigate to Project Detail
  static void _navigateToProject(
    BuildContext context,
    String projectId,
    Map<String, dynamic>? data,
  ) async {
    debugPrint('📂 [NotificationNavigator] _navigateToProject called');
    debugPrint('   - projectId: $projectId');
    debugPrint('   - data: $data');

    if (projectId.isEmpty) {
      debugPrint('❌ [NotificationNavigator] Empty projectId');
      _navigateToNotificationList(context);
      return;
    }

    debugPrint(
      '📂 [NotificationNavigator] Preparing navigation to project detail',
    );
    debugPrint('   - route: ${AppRoutes.projectDetail}');

    // ✅ Refresh project data before navigation
    final refreshSuccess = await _refreshProjectData(context, projectId);

    if (!refreshSuccess) {
      debugPrint(
        '⚠️ [NotificationNavigator] Refresh failed, but continuing...',
      );
    }

    // Prepare arguments
    final arguments = {
      'projectId': projectId,
      'projectName': data?['projectName'],
    };

    debugPrint('📦 [NotificationNavigator] Arguments: $arguments');

    // Navigate
    try {
      Navigator.pushNamed(
        context,
        AppRoutes.projectDetail,
        arguments: arguments,
      );
      debugPrint('✅ [NotificationNavigator] pushNamed executed');
    } catch (e, stack) {
      debugPrint('❌ [NotificationNavigator] Navigation error: $e');
      debugPrint('Stack: $stack');
    }
  }

  /// Navigate to Meeting
  static void _navigateToMeeting(
    BuildContext context,
    String meetingId,
    Map<String, dynamic>? data,
  ) {
    debugPrint('📞 [NotificationNavigator] _navigateToMeeting called');
    debugPrint('   - meetingId: $meetingId');

    if (meetingId.isEmpty) {
      _navigateToNotificationList(context);
      return;
    }

    final meetingTitle = data?['meetingTitle'] as String? ?? meetingId;

    debugPrint('📞 [NotificationNavigator] Showing meeting snackbar');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📞 Navigate to meeting: $meetingTitle'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );

    // TODO: Implement meeting navigation
    // Navigator.pushNamed(
    //   context,
    //   AppRoutes.meeting,
    //   arguments: {
    //     'meetingId': meetingId,
    //     'userId': data?['userId'],
    //     'cameraOn': false,
    //     'micOn': false,
    //   },
    // );
  }

  /// Fallback: Navigate to Notification List
  static void _navigateToNotificationList(BuildContext context) {
    debugPrint('🔔 [NotificationNavigator] _navigateToNotificationList called');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔔 Xem danh sách thông báo'),
        duration: Duration(seconds: 2),
      ),
    );

    // TODO: Implement notification list navigation
    // Navigator.pushNamed(context, AppRoutes.notificationList);
  }
}
