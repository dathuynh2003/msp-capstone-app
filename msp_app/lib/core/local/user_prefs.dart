import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static Future<void> saveUser({
    required String userId,
    required String email,
    required String fullName,
    required String avatarUrl,
    required String role,
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('email', email);
    await prefs.setString('fullName', fullName);
    await prefs.setString('avatarUrl', avatarUrl);
    await prefs.setString('role', role);
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'email': prefs.getString('email'),
      'fullName': prefs.getString('fullName'),
      'avatarUrl': prefs.getString('avatarUrl'),
      'role': prefs.getString('role'),
      'accessToken': prefs.getString('accessToken'),
      'refreshToken': prefs.getString('refreshToken'),
    };
  }
}
