import 'package:msp_app/core/core.dart';
import '../models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponseModel> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        body: {
          'username': username,
          'password': password,
        },
      );
      
      return LoginResponseModel.fromJson(response);
    } on AuthException {
      rethrow;
    } catch (e) {
      // For demo purposes, keep the mock logic
      if (username == "admin" && password == "123") {
        return LoginResponseModel(token: "fake_token_123");
      } else {
        throw const AuthException(message: "Invalid username or password");
      }
    }
  }
}
