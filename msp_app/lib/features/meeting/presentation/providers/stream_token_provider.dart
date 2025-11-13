import 'package:flutter_riverpod/flutter_riverpod.dart';
// import các repository/datasource như đã cấu trúc
import '../../data/datasources/stream_token_remote_datasource.dart';
import '../../data/repositories/stream_token_repository_impl.dart';
import '../../domain/usecases/get_stream_token_usecase.dart';

// Provider cho datasource
final streamTokenDatasourceProvider = Provider(
  (ref) => StreamTokenRemoteDatasource(),
);
// Provider repo
final streamTokenRepositoryProvider = Provider(
  (ref) => StreamTokenRepositoryImpl(ref.read(streamTokenDatasourceProvider)),
);
// Provider usecase
final getStreamTokenUseCaseProvider = Provider(
  (ref) => GetStreamTokenUseCase(ref.read(streamTokenRepositoryProvider)),
);
// Provider gọi lấy token (nên dùng Family để truyền param động)
final getStreamTokenProvider =
    FutureProvider.family<String, Map<String, String>>((ref, param) async {
      final usecase = ref.read(getStreamTokenUseCaseProvider);
      return await usecase(
        userId: param['userId']!,
        userName: param['userName'] ?? '',
        imageUrl: param['imageUrl'] ?? '',
      );
    });
