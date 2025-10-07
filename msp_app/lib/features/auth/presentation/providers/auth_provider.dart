import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/di/injection_container.dart';
import 'package:msp_app/features/auth/domain/usecases/login_usecase.dart';

class AuthState {
  final bool isLoading;
  final String? token;
  final String? error;

  AuthState({this.isLoading = false, this.token, this.error});

  AuthState copyWith({bool? isLoading, String? token, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthNotifier({required LoginUseCase loginUseCase}) 
      : _loginUseCase = loginUseCase,
        super(AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _loginUseCase(LoginParams(
        username: username,
        password: password,
      ));

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (user) {
          state = state.copyWith(
            isLoading: false,
            token: 'fake_token_123', // Using mock token for now
          );
        },
      );

      return state.token != null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
      return false;
    }
  }

  void logout() {
    state = AuthState(); // Reset to initial state
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(loginUseCase: sl<LoginUseCase>());
});
