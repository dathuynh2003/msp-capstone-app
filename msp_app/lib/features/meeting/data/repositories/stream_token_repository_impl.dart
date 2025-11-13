import '../../domain/repositories/stream_token_repository.dart';
import '../datasources/stream_token_remote_datasource.dart';

class StreamTokenRepositoryImpl implements StreamTokenRepository {
  final StreamTokenRemoteDatasource datasource;
  StreamTokenRepositoryImpl(this.datasource);

  @override
  Future<String> getStreamToken({
    required String userId,
    required String userName,
    required String imageUrl,
  }) {
    return datasource.getStreamToken(
      userId: userId,
      userName: userName,
      imageUrl: imageUrl,
    );
  }
}
