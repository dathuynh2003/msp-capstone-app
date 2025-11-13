abstract class StreamTokenRepository {
  Future<String> getStreamToken({
    required String userId,
    required String userName,
    required String imageUrl,
  });
}
