import 'package:msp_app/core/errors/exceptions.dart';
import 'package:msp_app/shared/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String username, String password) async {
    try {
      final result = await remoteDataSource.login(username, password);
      return result.toEntity();
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'Login failed: ${e.toString()}');
    }
  }
}
