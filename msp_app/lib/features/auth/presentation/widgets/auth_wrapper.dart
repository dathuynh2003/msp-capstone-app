import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import '../providers/auth_provider.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});
  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final userMap = await UserPrefs.getUser();
    final accessToken = userMap['accessToken'];

    // Trường hợp prefs chưa có data hoặc accessToken == null || rỗng
    if (accessToken == null || accessToken.isEmpty) {
      // Chưa đăng nhập, phải vào màn hình Login
      await UserPrefs.clear();
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Nếu có token, kiểm tra hạn dùng
    if (!JwtDecoder.isExpired(accessToken)) {
      final role = userMap['role'];
      ref.read(authProvider.notifier).setSessionFromPrefs(userMap);
      if (mounted) {
        if (role == "Member") {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (role == "ProjectManager") {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } else {
      // Token hết hạn, vẫn phải về Login
      await UserPrefs.clear();
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
