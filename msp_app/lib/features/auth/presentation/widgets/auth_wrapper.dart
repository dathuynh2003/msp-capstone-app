import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:msp_app/core/constants/app_constants.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import '../providers/auth_provider.dart';
import 'package:msp_app/features/meeting/presentation/providers/stream_token_provider.dart';
import 'package:msp_app/core/services/stream_video_service.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});
  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initSessionAndStream();
  }

  Future<void> _initSessionAndStream() async {
    try {
      final userMap = await UserPrefs.getUser();
      final accessToken = userMap['accessToken'];

      if (accessToken == null || accessToken.isEmpty) {
        await UserPrefs.clear();
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // Nếu token hợp lệ
      if (!JwtDecoder.isExpired(accessToken)) {
        final role = userMap['role'];
        // Set lại session auth cho app, như flow cũ
        ref.read(authProvider.notifier).setSessionFromPrefs(userMap);

        // Lấy Stream token qua provider riverpod (đúng clean arch)
        final asyncToken = await ref.read(
          getStreamTokenProvider({
            'userId': userMap['userId']!,
            'userName': userMap['fullName'] ?? '',
            'imageUrl': userMap['avatarUrl'] ?? '',
          }).future,
        );

        // Init StreamVideoService
        StreamVideoService.init(
          apiKey: AppConstants.streamApiKey,
          userId: userMap['userId']!,
          userToken: asyncToken,
          userName: userMap['fullName'] ?? '',
        );

        // Điều hướng như cũ
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
        await UserPrefs.clear();
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        _error = 'Lỗi auth: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Nếu có lỗi
    return Scaffold(body: Center(child: Text(_error ?? 'Lỗi không xác định')));
  }
}
