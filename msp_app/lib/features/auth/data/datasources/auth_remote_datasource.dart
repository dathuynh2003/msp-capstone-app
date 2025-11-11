import '../../../../core/network/api_config.dart';
import '../../../../core/network/http_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../../../../core/models/api_response.dart';
import 'dart:convert';

class AuthRemoteDatasource {
  Future<LoginResponse> login(LoginRequest request) async {
    final uri = Uri.parse("${ApiConfig.apiBaseUrl}/auth/login");
    final response = await HttpClient.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );
    final data = jsonDecode(response.body);

    final apiRes = ApiResponse<LoginResponse>.fromJson(
      data,
      (json) => LoginResponse.fromJson(json),
    );
    if (response.statusCode == 200 && apiRes.success) {
      if (apiRes.data == null) throw Exception("No login data returned!");
      return apiRes.data!;
    } else {
      throw Exception(apiRes.message);
    }
  }
}
