import 'package:stream_video_flutter/stream_video_flutter.dart';

class StreamVideoService {
  static StreamVideo? _client;
  static StreamVideo get client => _client!;

  static void init({
    required String apiKey,
    required String userId,
    required String userToken,
    String? userName,
  }) {
    _client = StreamVideo(
      apiKey,
      user: User.regular(userId: userId, name: userName ?? "", role: "user"),
      userToken: userToken,
    );
  }
}
