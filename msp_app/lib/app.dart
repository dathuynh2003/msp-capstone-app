import 'package:flutter/material.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/member_dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng MSP',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MemberDashboardPage(),
        // '/dashboard': (context) => const PMDashboardPage(),
      },
    );
  }
}
