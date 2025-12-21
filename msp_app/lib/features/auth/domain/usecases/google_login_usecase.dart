import '../entities/user_token_entity.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/google_login_request.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<UserTokenEntity> call(GoogleLoginRequest request) {
    return repository.googleLogin(request);
  }
}
