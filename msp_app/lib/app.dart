import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:msp_app/core/services/background_service.dart';
import 'core/services/local_notification_service.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/member_home_page.dart';
import 'features/meeting/presentation/pages/join_meeting_page.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final _localNotificationService = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Detect app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        debugPrint('📴 [App Lifecycle] App paused (background)');
        // App đi vào background - SignalR có thể disconnect
        break;

      case AppLifecycleState.resumed:
        debugPrint('📱 [App Lifecycle] App resumed (foreground)');
        // App quay lại foreground - SignalR nên reconnect
        break;

      case AppLifecycleState.inactive:
        debugPrint('⏸️ [App Lifecycle] App inactive');
        break;

      case AppLifecycleState.detached:
        debugPrint('🔌 [App Lifecycle] App detached');
        break;

      case AppLifecycleState.hidden:
        debugPrint('👻 [App Lifecycle] App hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng MSP',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      navigatorKey: BackgroundServiceHelper.navigatorKey,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MemberHomePage(),
        '/meeting': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return JoinMeetingPage(
            meetingId: args['meetingId'],
            userId: args['userId'],
            cameraOn: args['cameraOn'],
            micOn: args['micOn'],
          );
        },
        // TODO: Thêm routes cho project/task detail
      },
    );
  }
}
