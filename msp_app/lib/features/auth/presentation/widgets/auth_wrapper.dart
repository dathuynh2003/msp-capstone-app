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

      // FIX: Đúng userId là email nếu React cũng dùng email
      final userId = userMap['userId'] ?? '';
      final userName = userMap['fullName'] ?? '';

      if (accessToken == null || accessToken.isEmpty) {
        await UserPrefs.clear();
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      if (!JwtDecoder.isExpired(accessToken)) {
        final role = userMap['role'];
        ref.read(authProvider.notifier).setSessionFromPrefs(userMap);

        // Đúng token cho đúng userId/email
        final asyncToken = await ref.read(
          getStreamTokenProvider({
            'userId': userId,
            'userName': userName,
            'imageUrl': userMap['avatarUrl'] ?? '',
          }).future,
        );

        print('---STREAM MOBILE DEBUG---');
        print('userId: $userId');
        print('userName: $userName');
        print('userToken: $asyncToken');
        print('apiKey: ${AppConstants.streamApiKey}');
        print('-------------------------');

        StreamVideoService.init(
          apiKey: AppConstants.streamApiKey,
          userId: userId,
          userToken: asyncToken,
          userName: userName,
          imageUrl: userMap['avatarUrl'],
        );

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
    } catch (e, stack) {
      print('GET STREAM TOKEN ERROR: $e\n$stack');
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
    return Scaffold(body: Center(child: Text(_error ?? 'Lỗi không xác định')));
  }
}
