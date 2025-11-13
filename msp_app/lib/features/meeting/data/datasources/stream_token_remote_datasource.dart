import '../../../../core/network/api_config.dart';
import '../../../../core/network/http_client.dart';
import 'dart:convert';

class StreamTokenRemoteDatasource {
  Future<String> getStreamToken({
    required String userId,
    required String userName,
    required String imageUrl,
    String role = 'user',
  }) async {
    final uri = Uri.parse('${ApiConfig.apiBaseUrl}/stream/register');
    final response = await HttpClient.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'id': userId,
        'name': userName,
        'role': role,
        'image': imageUrl,
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['token'] != null) {
      return data['token'];
    } else {
      throw Exception(data['message'] ?? 'Không lấy được Stream token!');
    }
  }
}
