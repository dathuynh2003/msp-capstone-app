import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import 'package:msp_app/core/services/fcm_service_provider.dart';
import 'package:msp_app/core/services/signalr_service_provider.dart';
import 'package:msp_app/features/auth/data/models/google_login_request.dart';
import 'package:msp_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:msp_app/features/home/presentation/providers/user_provider.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/user_token_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';

class AuthState {
  final bool loading;
  final UserTokenEntity? token;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.loading = false,
    this.token,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? loading,
    UserTokenEntity? token,
    String? error,
    bool? isAuthenticated,
  }) => AuthState(
    loading: loading ?? this.loading,
    token: token ?? this.token,
    error: error,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
  );
}

class AuthProvider extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final GoogleSignIn googleSignIn;
  final Ref ref;

  AuthProvider(
    this.loginUseCase,
    this.googleLoginUseCase,
    this.googleSignIn,
    this.ref,
  ) : super(const AuthState());

  Future<void> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      state = state.copyWith(
        loading: false,
        error: 'Email and password are required',
      );
      return;
    }

    state = state.copyWith(loading: true, error: null);

    try {
      final token = await loginUseCase(email, password);

      if (token.accessToken.isEmpty) {
        throw Exception('Invalid token received');
      }

      if (JwtDecoder.isExpired(token.accessToken)) {
        throw Exception('Token has expired');
      }

      final decoded = JwtDecoder.decode(token.accessToken);

      if (decoded['userId'] == null || decoded['email'] == null) {
        throw Exception('Invalid token payload');
      }

      final roles = (decoded['role'] as String?)?.split(',') ?? [];
      final mainRole = roles.isNotEmpty ? roles.first : 'user';

      final userToken = UserTokenEntity(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        userId: decoded['userId'],
        email: decoded['email'],
        fullName: decoded['fullName'] ?? '',
        avatarUrl: decoded['avatarUrl'] ?? '',
        role: mainRole,
      );

      // Save to SharedPreferences
      await UserPrefs.saveUser(
        userId: userToken.userId,
        email: userToken.email,
        fullName: userToken.fullName,
        avatarUrl: userToken.avatarUrl,
        role: userToken.role,
        accessToken: userToken.accessToken,
        refreshToken: userToken.refreshToken,
      );

      // ✅ NEW: Save remember me credentials if checked
      if (rememberMe) {
        await UserPrefs.saveRememberMe(email: email.trim(), password: password);
        print('✅ Remember me enabled');
      } else {
        // Clear remember me if unchecked
        await UserPrefs.clearRememberMe();
        print('✅ Remember me disabled');
      }

      state = state.copyWith(
        loading: false,
        token: userToken,
        isAuthenticated: true,
        error: null,
      );

      ref.read(userProvider.notifier).state = UserInfo(
        userId: userToken.userId,
        userName: userToken.fullName,
        email: userToken.email,
        role: userToken.role,
        avatarUrl: userToken.avatarUrl,
      );

      print('✅ UserProvider updated after login');

      await _connectSignalRAndRegisterFCM();
    } on Exception catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isAuthenticated: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'An unexpected error occurred. Please try again.',
        isAuthenticated: false,
      );
      print('❌ Login error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(loading: true, error: null);

    try {
      print('🔍 Starting Google Sign-In...');

      // Step 1: Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        print('⚠️ Google Sign-In canceled by user');
        state = state.copyWith(
          loading: false,
          error: 'Sign in canceled',
          isAuthenticated: false,
        );
        return;
      }

      print('✅ Google user selected: ${googleUser.email}');

      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      print('✅ Google ID Token obtained');

      // Step 3: Prepare request for backend
      final request = GoogleLoginRequest(
        idToken: idToken,
        googleId: googleUser.id,
        email: googleUser.email,
        firstName: googleUser.displayName?.split(' ').first ?? '',
        lastName: googleUser.displayName?.split(' ').skip(1).join(' ') ?? '',
        avatarUrl: googleUser.photoUrl,
      );

      print('📤 Sending Google login request to backend...');

      // Step 4: Call backend API via UseCase
      final userToken = await googleLoginUseCase(request);

      print('✅ Backend login successful');
      print('Access Token: ${userToken.accessToken.substring(0, 20)}...');

      // Step 5: Validate token
      if (userToken.accessToken.isEmpty) {
        throw Exception('Invalid token received');
      }

      if (JwtDecoder.isExpired(userToken.accessToken)) {
        throw Exception('Token has expired');
      }

      // Step 6: Save session
      await UserPrefs.saveUser(
        userId: userToken.userId,
        email: userToken.email,
        fullName: userToken.fullName,
        avatarUrl: userToken.avatarUrl,
        role: userToken.role,
        accessToken: userToken.accessToken,
        refreshToken: userToken.refreshToken,
      );

      print('✅ Session saved');

      // Step 7: Update state
      state = state.copyWith(
        loading: false,
        token: userToken,
        isAuthenticated: true,
        error: null,
      );

      // Step 8: Update UserProvider
      ref.read(userProvider.notifier).state = UserInfo(
        userId: userToken.userId,
        userName: userToken.fullName,
        email: userToken.email,
        role: userToken.role,
        avatarUrl: userToken.avatarUrl,
      );

      print('✅ UserProvider updated after Google login');

      // Step 9: Connect SignalR and register FCM
      await _connectSignalRAndRegisterFCM();

      print('✅ Google Sign-In completed successfully');
    } on Exception catch (e) {
      print('❌ Google Sign-In error: $e');

      // Sign out from Google on error
      await googleSignIn.signOut();

      state = state.copyWith(
        loading: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isAuthenticated: false,
      );
    } catch (e) {
      print('❌ Google Sign-In unexpected error: $e');

      // Sign out from Google on error
      await googleSignIn.signOut();

      state = state.copyWith(
        loading: false,
        error: 'Google sign-in failed. Please try again.',
        isAuthenticated: false,
      );
    }
  }

  Future<void> _connectSignalRAndRegisterFCM() async {
    try {
      final signalRService = ref.read(signalRServiceProvider);
      await signalRService.connect();
      print('✅ SignalR connected');

      final fcmService = ref.read(fcmServiceProvider);
      await fcmService.sendTokenToBackend();
      print('✅ FCM token registered');
    } catch (e) {
      print('⚠️ SignalR/FCM setup failed: $e');
    }
  }

  Future<void> setSessionFromPrefs(Map<String, String?> userMap) async {
    final accessToken = userMap['accessToken'] ?? '';

    if (accessToken.isEmpty) {
      state = const AuthState();
      return;
    }

    if (JwtDecoder.isExpired(accessToken)) {
      print('⚠️ Stored token is expired, clearing session');
      await UserPrefs.clear();
      state = const AuthState();
      return;
    }

    final userToken = UserTokenEntity(
      accessToken: accessToken,
      refreshToken: userMap['refreshToken'] ?? '',
      userId: userMap['userId'] ?? '',
      email: userMap['email'] ?? '',
      fullName: userMap['fullName'] ?? '',
      avatarUrl: userMap['avatarUrl'] ?? '',
      role: userMap['role'] ?? '',
    );

    state = state.copyWith(
      token: userToken,
      loading: false,
      error: null,
      isAuthenticated: true,
    );

    // ✅ UPDATE: Sync UserProvider when restoring session
    ref.read(userProvider.notifier).state = UserInfo(
      userId: userToken.userId,
      userName: userToken.fullName,
      email: userToken.email,
      role: userToken.role,
      avatarUrl: userToken.avatarUrl,
    );

    print('✅ UserProvider updated from session');

    await _connectSignalRAndRegisterFCM();
  }

  Future<void> logout() async {
    try {
      final fcmService = ref.read(fcmServiceProvider);
      await fcmService.deactivateToken();
      print('✅ FCM token deactivated');

      final signalRService = ref.read(signalRServiceProvider);
      await signalRService.disconnect();
      print('✅ SignalR disconnected');

      await googleSignIn.signOut();
      print('✅ Google sign-out completed');
    } catch (e) {
      print('⚠️ Logout cleanup error: $e');
    }

    // Clear local storage
    await UserPrefs.clearSession();

    // Reset auth state
    state = const AuthState(
      loading: false,
      token: null,
      error: null,
      isAuthenticated: false,
    );

    // ✅ UPDATE: Clear UserProvider on logout
    ref.read(userProvider.notifier).state = UserInfo.empty();

    print('✅ Auth state and UserProvider reset');
  }

  bool get isAuthenticated => state.isAuthenticated;
  UserTokenEntity? get currentUser => state.token;
}

// ✅ Google Sign-In Provider
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
    // Optional: Add your OAuth client ID if needed
    clientId:
        '849400278984-idr141p1i1nblncj2cab6t8q8ktmfshq.apps.googleusercontent.com',
  );
});

// ✅ Google Login UseCase Provider
final googleLoginUseCaseProvider = Provider<GoogleLoginUseCase>((ref) {
  return GoogleLoginUseCase(AuthRepositoryImpl(AuthRemoteDatasource()));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(AuthRepositoryImpl(AuthRemoteDatasource()));
});

final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
  (ref) => AuthProvider(
    ref.read(loginUseCaseProvider),
    ref.read(googleLoginUseCaseProvider),
    ref.read(googleSignInProvider),
    ref,
  ),
);

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserTokenEntity?>((ref) {
  return ref.watch(authProvider).token;
});
