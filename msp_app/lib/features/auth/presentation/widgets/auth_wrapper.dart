// In auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:msp_app/core/constants/app_constants.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import '../providers/auth_provider.dart';
import 'package:msp_app/features/meeting/presentation/providers/stream_token_provider.dart';
import 'package:msp_app/core/services/stream_video_service.dart';

const Color orangeDeep = Color(0xFFFFA463);

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
      debugPrint('🔍 [AuthWrapper] Checking existing session...');

      final userMap = await UserPrefs.getUser();
      final accessToken = userMap['accessToken'];
      final userId = userMap['userId'] ?? '';
      final userName = userMap['fullName'] ?? '';

      // ✅ Only check existing session - NO auto-login
      if (accessToken != null &&
          accessToken.isNotEmpty &&
          !JwtDecoder.isExpired(accessToken)) {
        debugPrint('✅ [AuthWrapper] Valid session found, restoring...');

        // Restore auth state
        ref.read(authProvider.notifier).setSessionFromPrefs(userMap);

        // Get Stream token
        final asyncToken = await ref.read(
          getStreamTokenProvider({
            'userId': userId,
            'userName': userName,
            'imageUrl': userMap['avatarUrl'] ?? '',
          }).future,
        );

        debugPrint('---STREAM MOBILE DEBUG---');
        debugPrint('userId: $userId');
        debugPrint('userName: $userName');
        debugPrint('userToken: $asyncToken');
        debugPrint('apiKey: ${AppConstants.streamApiKey}');
        debugPrint('-------------------------');

        // Initialize Stream Video
        StreamVideoService.init(
          apiKey: AppConstants.streamApiKey,
          userId: userId,
          userToken: asyncToken,
          userName: userName,
          imageUrl: userMap['avatarUrl'],
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // ✅ No valid session → Go to login page
        // Remember me credentials will be loaded in LoginPage
        // Clear session only, keep remember me
        debugPrint('⚠️ [AuthWrapper] No valid session, going to login');
        await UserPrefs.clearSession();

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e, stack) {
      debugPrint('❌ [AuthWrapper] Error: $e\n$stack');
      setState(() {
        _error = 'Authentication error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF4E6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: orangeDeep.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.people_alt_outlined,
                  size: 48,
                  color: orangeDeep,
                ),
              ),
              const SizedBox(height: 24),
              CircularProgressIndicator(color: orangeDeep, strokeWidth: 3),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF4E6),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 24),
                Text(
                  'Authentication Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Go to Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeDeep,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
