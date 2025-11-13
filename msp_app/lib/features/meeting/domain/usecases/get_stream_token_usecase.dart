import '../repositories/stream_token_repository.dart';

class GetStreamTokenUseCase {
  final StreamTokenRepository repo;
  GetStreamTokenUseCase(this.repo);

  Future<String> call({
    required String userId,
    required String userName,
    required String imageUrl,
  }) {
    return repo.getStreamToken(
      userId: userId,
      userName: userName,
      imageUrl: imageUrl,
    );
  }
}
