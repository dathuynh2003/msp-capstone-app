import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/member_dashboard_page.dart';
import 'features/home/presentation/pages/pm_dashboard_page.dart';
import 'features/project/presentation/pages/list_projects_page.dart';
import 'core/services/auth_service.dart';
import 'shared/entities/user.dart';

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
        '/dashboard': (context) => const PMDashboardPage(),
        '/projects': (context) => const ListProjectsPage(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    final user = await AuthService.getCurrentUser();
    
    if (mounted) {
      if (isLoggedIn && user != null) {
        // User is logged in, navigate to appropriate page
        if (user.role == UserRole.member) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (user.role == UserRole.projectManager) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // For other roles (adminSystem, businessOwner), go to home for now
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // User is not logged in, go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
