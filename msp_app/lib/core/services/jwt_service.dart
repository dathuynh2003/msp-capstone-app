import 'dart:convert';
import 'package:msp_app/shared/entities/user.dart';

class JWTService {
  // Generate fake JWT token for demo purposes
  static String generateFakeJWT(User user) {
    final header = {
      'alg': 'HS256',
      'typ': 'JWT'
    };
    
    final payload = {
      'sub': user.id,
      'email': user.email,
      'name': user.name,
      'role': user.role.name,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    };

    // Simple base64 encoding (not real JWT, just for demo)
    final headerEncoded = base64Url.encode(utf8.encode(json.encode(header)));
    final payloadEncoded = base64Url.encode(utf8.encode(json.encode(payload)));
    final signature = base64Url.encode(utf8.encode('fake_signature_${user.id}'));
    
    return '$headerEncoded.$payloadEncoded.$signature';
  }

  // Decode JWT payload (for demo purposes)
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = json.decode(utf8.decode(base64Url.decode(parts[1])));
      return payload as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      final payload = decodePayload(token);
      if (payload == null) return true;
      
      final exp = payload['exp'] as int?;
      if (exp == null) return true;
      
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return now >= exp;
    } catch (e) {
      return true;
    }
  }

  // Get user ID from token
  static String? getUserId(String token) {
    final payload = decodePayload(token);
    return payload?['sub'] as String?;
  }

  // Get user role from token
  static String? getUserRole(String token) {
    final payload = decodePayload(token);
    return payload?['role'] as String?;
  }

  // Get user email from token
  static String? getUserEmail(String token) {
    final payload = decodePayload(token);
    return payload?['email'] as String?;
  }

  // Get token expiration time
  static DateTime? getExpirationTime(String token) {
    try {
      final payload = decodePayload(token);
      if (payload == null) return null;
      
      final exp = payload['exp'] as int?;
      if (exp == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      return null;
    }
  }

  // Get token issued time
  static DateTime? getIssuedTime(String token) {
    try {
      final payload = decodePayload(token);
      if (payload == null) return null;
      
      final iat = payload['iat'] as int?;
      if (iat == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(iat * 1000);
    } catch (e) {
      return null;
    }
  }

  // Validate token format (basic validation)
  static bool isValidFormat(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      
      // Try to decode each part
      base64Url.decode(parts[0]);
      base64Url.decode(parts[1]);
      base64Url.decode(parts[2]);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get token info for debugging
  static Map<String, dynamic> getTokenInfo(String token) {
    final payload = decodePayload(token);
    if (payload == null) {
      return {'error': 'Invalid token'};
    }

    return {
      'userId': payload['sub'],
      'email': payload['email'],
      'name': payload['name'],
      'role': payload['role'],
      'issuedAt': getIssuedTime(token)?.toIso8601String(),
      'expiresAt': getExpirationTime(token)?.toIso8601String(),
      'isExpired': isTokenExpired(token),
      'isValidFormat': isValidFormat(token),
    };
  }
}

