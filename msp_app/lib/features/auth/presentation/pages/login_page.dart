import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/auth/presentation/pages/demo_accounts_page.dart';
import 'package:msp_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:msp_app/features/auth/presentation/widgets/login_header.dart';
import 'package:msp_app/features/home/presentation/pages/member_dashboard_page.dart';
import 'package:msp_app/features/home/presentation/pages/pm_dashboard_page.dart';
import 'package:msp_app/core/services/auth_service.dart';
import 'package:msp_app/shared/shared.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLogin = true;
  bool _rememberMe = false;

  void _onSubmit(String email, String password, String? companyName) async {
    if (_isLogin) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Use AuthService for authentication
        final result = await AuthService.login(email, password);
        
        // Hide loading indicator
        if (mounted) Navigator.pop(context);
        
        if (result['success']) {
          final user = result['user'] as User;
          final token = result['token'] as String;
          
          // Navigate based on role
          Widget destination;
          if (user.role == UserRole.member) {
            destination = const MemberDashboardPage();
          } else if (user.role == UserRole.projectManager) {
            destination = const PMDashboardPage();
          } else {
            destination = const MemberDashboardPage();
          }
          
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => destination),
            );
            
        // Show welcome message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chào mừng, ${user.name}! (${user.roleDisplayName})'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Xem Token',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('JWT Token'),
                    content: SelectableText(
                      token,
                      style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Đóng'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
          }
        } else {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['error'] ?? 'Đăng nhập thất bại'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Hide loading indicator
        if (mounted) Navigator.pop(context);
        
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi đăng nhập: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tài khoản đã được tạo! Vui lòng đăng nhập.")),
      );
      setState(() => _isLogin = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDF0D2), Color(0xFFF9F4EE)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LoginHeader(),
              AuthForm(
                isLogin: _isLogin,
                rememberMe: _rememberMe,
                onRememberMeChanged: (val) => setState(() => _rememberMe = val),
                onSubmit: _onSubmit,
                onSwitchMode: () => setState(() => _isLogin = !_isLogin),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DemoAccountsPage(),
                    ),
                  );
                },
                child: const Text(
                  'Xem Tài Khoản Demo',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
