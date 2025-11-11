import 'package:http/http.dart' as http;

class HttpClient {
  static final http.Client _client = http.Client();

  static http.Client get client => _client;

  // Optional: add method for GET, POST, etc. nếu muốn wrap cho logging/error/retry
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client.post(url, headers: headers, body: body);
  }
}
