import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:msp_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:msp_app/features/auth/presentation/widgets/login_header.dart';
import 'package:msp_app/features/home/presentation/pages/member_dashboard_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLogin = true;
  bool _rememberMe = false;

  //sử dụng Riverpod provider
  void _onSubmit(String email, String password, String? companyName) async {
    if (_isLogin) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await ref.read(authProvider.notifier).login(email, password);

        // Hide loading indicator
        if (mounted) Navigator.pop(context);

        final state = ref.read(authProvider);

        if (state.token != null) {
          // Lấy token từ state.token.accessToken
          // Nếu muốn lấy user-info, cần thêm phần call lấy user sau login (nếu API trả luôn)
          // Demo: navigate theo role/fake
          Widget destination = const MemberDashboardPage();

          if (mounted)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => destination),
            );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng nhập thành công!'),
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
                        state.token!.accessToken,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
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
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Đăng nhập thất bại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng nhập: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tài khoản đã được tạo! Vui lòng đăng nhập."),
        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
