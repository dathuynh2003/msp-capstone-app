import 'package:msp_app/features/auth/data/models/google_login_request.dart';

import '../entities/user_token_entity.dart';

abstract class AuthRepository {
  Future<UserTokenEntity> login(String email, String password);
  Future<UserTokenEntity> googleLogin(GoogleLoginRequest request);
}
