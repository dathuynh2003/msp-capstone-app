import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';

/// Provider for Stream Video Client
final streamVideoClientProvider = Provider<StreamVideo?>((ref) {
  try {
    return GetIt.instance<StreamVideo>();
  } catch (e) {
    return null;
  }
});

/// Stream Video Provider Widget
class StreamVideoProvider extends ConsumerStatefulWidget {
  final Widget child;

  const StreamVideoProvider({super.key, required this.child});

  @override
  ConsumerState<StreamVideoProvider> createState() =>
      _StreamVideoProviderState();
}

class _StreamVideoProviderState extends ConsumerState<StreamVideoProvider> {
  StreamVideo? _videoClient;
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeStreamClient();
  }

  Future<void> _initializeStreamClient() async {
    try {
      // Get API key from environment variables
      // final apiKey = dotenv.env['STREAM_API_KEY'] ?? '';
      final apiKey = '9tkscc7pwskt';

      if (apiKey.isEmpty) {
        setState(() {
          _isInitialized = true;
          _error = "Stream API key not configured";
        });
        return;
      }

      final currentUser = await AuthService.getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _isInitialized = true;
          _error = 'User chưa đăng nhập';
        });
        return;
      }

      // final userToken = await _getUserTokenFromBackend(currentUser);
      // if (userToken == null) {
      //   setState(() {
      //     _isInitialized = true;
      //     _error = 'Không thể lấy token từ backend';
      //   });
      //   return;
      // }

      try {
        // Initialize real StreamVideo client
        _videoClient = StreamVideo(
          apiKey,
          // user: User.regular(userId: currentUser.id, name: currentUser.name),
          // userToken: userToken,
          user: User.anonymous(),
        );

        // Wait for client to be fully initialized
        await _videoClient!.connect();
        // Register real client in GetIt
        _registerClient(_videoClient!);
      } catch (e) {
        throw e; // Re-throw to be caught by outer try-catch
      }

      setState(() {
        _isInitialized = true;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isInitialized = true;
        _error = "Failed to initialize video client: $e";
      });
    }
  }

  @override
  void dispose() {
    _videoClient?.dispose();
    super.dispose();
  }

  /// Register a client in GetIt
  void _registerClient(StreamVideo client) {
    try {
      if (GetIt.instance.isRegistered<StreamVideo>()) {
        GetIt.instance.unregister<StreamVideo>();
      }
      GetIt.instance.registerSingleton<StreamVideo>(client);
    } catch (e) {}
  }

  /// Get user token from backend API
  // Future<String?> _getUserTokenFromBackend(app_user.User user) async {
  //   try {
  //     // Get backend URL from environment variables
  //     final backendUrl = 'http://10.0.2.2:7213/api';

  //     // Prepare request body
  //     final requestBody = {
  //       'id': user.id,
  //       'name': user.name,
  //       'role': 'user',
  //       'image': user.avatar,
  //     };

  //     // Make API call to backend
  //     final response = await http.post(
  //       Uri.parse('$backendUrl/stream/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       final token = responseData['token'] as String?;
  //       if (token != null) {
  //         return token;
  //       } else {
  //         return null;
  //       }
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // If there's an error (like missing API key), render children without StreamVideo wrapper
    if (_error != null) {
      return widget.child;
    }

    if (!_isInitialized || _videoClient == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // Return children wrapped with StreamVideo context
    return widget.child;
  }
}
