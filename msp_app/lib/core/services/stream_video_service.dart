import 'package:stream_video_flutter/stream_video_flutter.dart';

// Chuẩn init video client
class StreamVideoService {
  static StreamVideo? _instance;

  static void init({
    required String apiKey,
    required String userId,
    required String userToken,
    required String userName,
    String? imageUrl,
  }) {
    _instance = StreamVideo(
      apiKey,
      user: User(
        info: UserInfo(id: userId, name: userName, image: imageUrl),
      ),
      userToken: userToken,
    );
  }

  static StreamVideo get instance {
    if (_instance == null)
      throw Exception('StreamVideoService chưa được khởi tạo');
    return _instance!;
  }
}
