import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/user_token_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';

// ---- AuthState & Provider ----
class AuthState {
  final bool loading;
  final UserTokenEntity? token;
  final String? error;

  const AuthState({this.loading = false, this.token, this.error});

  AuthState copyWith({bool? loading, UserTokenEntity? token, String? error}) =>
      AuthState(
        loading: loading ?? this.loading,
        token: token ?? this.token,
        error: error,
      );
}

class AuthProvider extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  AuthProvider(this.loginUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final token = await loginUseCase(email, password);

      // Decode JWT để lấy user info
      final decoded = JwtDecoder.decode(token.accessToken);
      final roles = (decoded['role'] as String).split(',');
      final mainRole = roles.isNotEmpty ? roles.first : '';

      // Lưu vào SharedPreferences
      await UserPrefs.saveUser(
        userId: decoded['userId'],
        email: decoded['email'],
        fullName: decoded['fullName'] ?? '',
        avatarUrl: decoded['avatarUrl'] ?? '',
        role: mainRole,
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );

      state = state.copyWith(loading: false, token: token);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // Set lại session khi khởi động lại app
  void setSessionFromPrefs(Map<String, String?> userMap) {
    if ((userMap['accessToken'] ?? '').isEmpty) return;
    state = state.copyWith(
      token: UserTokenEntity(
        accessToken: userMap['accessToken'] ?? '',
        refreshToken: userMap['refreshToken'] ?? '',
        userId: userMap['userId'] ?? '',
        email: userMap['email'] ?? '',
        fullName: userMap['fullName'] ?? '',
        avatarUrl: userMap['avatarUrl'] ?? '',
        role: userMap['role'] ?? '',
      ),
      loading: false,
      error: null,
    );
  }
}

// ---- Riverpod Provider ----
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(AuthRepositoryImpl(AuthRemoteDatasource()));
});
final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(ref.read(loginUseCaseProvider)),
);
