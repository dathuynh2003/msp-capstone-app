import 'package:http/http.dart' as http;
import 'package:msp_app/core/local/user_prefs.dart';

class HttpClient {
  static final http.Client _client = http.Client();

  static http.Client get client => _client;

  // ✅ Get headers with Authorization token
  static Future<Map<String, String>> getHeaders() async {
    final user = await UserPrefs.getUser();
    final token = user['accessToken'];

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ POST with auto headers
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final defaultHeaders = await getHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};
    return _client.post(url, headers: mergedHeaders, body: body);
  }

  // ✅ GET with auto headers
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final defaultHeaders = await getHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};
    return _client.get(url, headers: mergedHeaders);
  }

  // ✅ PUT with auto headers
  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final defaultHeaders = await getHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};
    return _client.put(url, headers: mergedHeaders, body: body);
  }

  // ✅ DELETE with auto headers
  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final defaultHeaders = await getHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};
    return _client.delete(url, headers: mergedHeaders, body: body);
  }

  // ✅ PATCH with auto headers (if needed)
  static Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final defaultHeaders = await getHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};
    return _client.patch(url, headers: mergedHeaders, body: body);
  }
}
