import 'package:jwt_decoder/jwt_decoder.dart';

import '../../domain/entities/user_token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserTokenEntity> login(String email, String password) async {
    final res = await remote.login(
      LoginRequest(email: email, password: password),
    );

    // Decode accessToken để lấy info
    final decoded = JwtDecoder.decode(res.accessToken);
    final roles = (decoded['role'] as String).split(',');
    final mainRole = roles.isNotEmpty ? roles.first : '';

    return UserTokenEntity(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
      userId: decoded['userId'] ?? '',
      email: decoded['email'] ?? '',
      fullName: decoded['fullName'] ?? '',
      avatarUrl: decoded['avatarUrl'] ?? '',
      role: mainRole,
    );
  }
}
