import '../entities/user_token_entity.dart';

abstract class AuthRepository {
  Future<UserTokenEntity> login(String email, String password);
}
