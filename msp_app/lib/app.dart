import 'package:flutter/material.dart';
import 'package:msp_app/core/services/background_service.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/member_home_page.dart';
import 'features/meeting/presentation/pages/join_meeting_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
        // '/dashboard': (context) => const PMDashboardPage(),
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
      },
    );
  }
}
