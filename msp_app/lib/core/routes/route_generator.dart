import 'package:flutter/material.dart';
import 'package:msp_app/features/task/presentation/pages/task_detail_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/widgets/auth_wrapper.dart';
import '../../features/home/presentation/pages/member_home_page.dart';
import '../../features/meeting/presentation/pages/join_meeting_page.dart';
import '../../features/project/presentation/pages/project_list_page.dart';
import '../../features/project/presentation/pages/project_detail_page.dart';

import 'app_routes.dart';

class RouteGenerator {
  /// Generate routes based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    // ✅ ADD: Debug log cho mọi route
    debugPrint('');
    debugPrint('========================================');
    debugPrint('🛣️ [RouteGenerator] Route: ${settings.name}');
    debugPrint('📦 [RouteGenerator] Arguments: $args');
    debugPrint('📦 [RouteGenerator] Arguments type: ${args.runtimeType}');
    debugPrint('========================================');

    switch (settings.name) {
      // ============ Auth Routes ============
      case '/':
        debugPrint('🏠 [RouteGenerator] → AuthWrapper');
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      case AppRoutes.login:
        debugPrint('🔐 [RouteGenerator] → LoginPage');
        return MaterialPageRoute(builder: (_) => const LoginPage());

      // ============ Home Routes ============
      case AppRoutes.home:
        debugPrint('🏠 [RouteGenerator] → MemberHomePage');
        return MaterialPageRoute(builder: (_) => const MemberHomePage());

      // ============ Project Routes ============
      case AppRoutes.projectList:
        debugPrint('📋 [RouteGenerator] → ProjectListPage');
        // final projectArgs = args as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProjectListPage(
            // highlightProjectId: projectArgs?['highlightProjectId'] as String?,
          ),
        );

      case AppRoutes.projectDetail:
        debugPrint('📂 [RouteGenerator] → ProjectDetailPage');

        if (args is! Map<String, dynamic>) {
          debugPrint(
            '❌ [RouteGenerator] Invalid arguments type: ${args.runtimeType}',
          );
          return _errorRoute('Invalid arguments for Project Detail');
        }

        final projectId = args['projectId'] as String?;
        final highlightTaskId = args['highlightTaskId'] as String?;

        debugPrint('   - projectId: $projectId');
        debugPrint('   - highlightTaskId: $highlightTaskId');

        if (projectId == null || projectId.isEmpty) {
          debugPrint('❌ [RouteGenerator] Missing or empty projectId');
          return _errorRoute('Missing projectId');
        }

        debugPrint('✅ [RouteGenerator] Creating ProjectDetailPage');
        return MaterialPageRoute(
          settings: settings, // ✅ ADD: Pass settings for navigation observer
          builder: (_) => ProjectDetailPage(
            projectId: projectId,
            highlightTaskId: highlightTaskId,
          ),
        );

      // ============ Meeting Routes ============
      case AppRoutes.meeting:
        debugPrint('📞 [RouteGenerator] → JoinMeetingPage');

        if (args is! Map<String, dynamic>) {
          debugPrint('❌ [RouteGenerator] Invalid meeting arguments');
          return _errorRoute('Invalid arguments for Meeting');
        }

        final meetingId = args['meetingId'] as String?;
        final userId = args['userId'] as String?;

        debugPrint('   - meetingId: $meetingId');
        debugPrint('   - userId: $userId');

        if (meetingId == null || userId == null) {
          debugPrint('❌ [RouteGenerator] Missing meetingId or userId');
          return _errorRoute('Missing meeting parameters');
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => JoinMeetingPage(
            meetingId: meetingId,
            userId: userId,
            cameraOn: args['cameraOn'] as bool? ?? false,
            micOn: args['micOn'] as bool? ?? false,
          ),
        );

      // ============ Task Routes ============
      case AppRoutes.taskDetail:
        debugPrint('📋 [RouteGenerator] → TaskDetailPage');

        if (args is! Map<String, dynamic>) {
          debugPrint(
            '❌ [RouteGenerator] Invalid arguments type: ${args.runtimeType}',
          );
          return _errorRoute('Invalid arguments for Task Detail');
        }

        final taskId = args['taskId'] as String?;
        final projectId = args['projectId'] as String?;
        final highlightCommentId =
            args['highlightCommentId'] as String?; // ✅ Add

        debugPrint('   - taskId: $taskId');
        debugPrint('   - projectId: $projectId');
        debugPrint('   - highlightCommentId: $highlightCommentId');

        if (taskId == null || taskId.isEmpty) {
          debugPrint('❌ [RouteGenerator] Missing or empty taskId');
          return _errorRoute('Missing taskId');
        }

        if (projectId == null || projectId.isEmpty) {
          debugPrint('❌ [RouteGenerator] Missing or empty projectId');
          return _errorRoute('Missing projectId');
        }

        debugPrint('✅ [RouteGenerator] Creating TaskDetailPage');
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => TaskDetailPage(
            taskId: taskId,
            projectId: projectId,
            highlightCommentId: highlightCommentId, // ✅ Pass commentId
          ),
        );

      // ============ Default/Error Routes ============
      default:
        debugPrint('⚠️ [RouteGenerator] Unknown route: ${settings.name}');
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Error route when navigation fails
  static Route<dynamic> _errorRoute(String message) {
    debugPrint('❌ [RouteGenerator] Error: $message');

    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Navigation Error'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
