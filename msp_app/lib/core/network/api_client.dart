import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  final String _baseUrl;
  
  ApiClient({
    required http.Client client,
    String? baseUrl,
  }) : _client = client,
       _baseUrl = baseUrl ?? AppConstants.baseUrl;
  
  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _client
          .get(uri, headers: _buildHeaders(headers))
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error occurred');
    } on FormatException {
      throw const NetworkException('Invalid response format');
    } catch (e) {
      if (e is TimeoutException) {
        throw const TimeoutException('Request timeout');
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
  
  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error occurred');
    } on FormatException {
      throw const NetworkException('Invalid response format');
    } catch (e) {
      if (e is TimeoutException) {
        throw const TimeoutException('Request timeout');
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
  
  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error occurred');
    } on FormatException {
      throw const NetworkException('Invalid response format');
    } catch (e) {
      if (e is TimeoutException) {
        throw const TimeoutException('Request timeout');
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
  
  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _client
          .delete(uri, headers: _buildHeaders(headers))
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error occurred');
    } on FormatException {
      throw const NetworkException('Invalid response format');
    } catch (e) {
      if (e is TimeoutException) {
        throw const TimeoutException('Request timeout');
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
  
  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final uri = Uri.parse('$_baseUrl${AppConstants.apiVersion}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }
  
  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body) as Map<String, dynamic>;
      case 400:
        throw const ServerException(
          message: 'Bad Request',
          statusCode: 400,
        );
      case 401:
        throw const AuthException(
          message: 'Unauthorized',
          code: 'UNAUTHORIZED',
        );
      case 403:
        throw const AuthException(
          message: 'Forbidden',
          code: 'FORBIDDEN',
        );
      case 404:
        throw const ServerException(
          message: 'Not Found',
          statusCode: 404,
        );
      case 500:
        throw const ServerException(
          message: 'Internal Server Error',
          statusCode: 500,
        );
      default:
        throw ServerException(
          message: 'Unexpected error occurred',
          statusCode: response.statusCode,
        );
    }
  }
}
