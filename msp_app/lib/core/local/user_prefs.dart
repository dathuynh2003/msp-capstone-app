// In user_prefs.dart - SIMPLE VERSION (No secure storage)
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

  // ✅ Save remember me (without secure storage)
  static Future<void> saveRememberMe({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', true);
    await prefs.setString('rememberedEmail', email);
    await prefs.setString(
      'rememberedPassword',
      password,
    ); // Less secure but works
  }

  // ✅ Get remember me
  static Future<Map<String, String?>> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (!rememberMe) {
      return {'email': null, 'password': null};
    }

    return {
      'email': prefs.getString('rememberedEmail'),
      'password': prefs.getString('rememberedPassword'),
    };
  }

  // ✅ Clear remember me
  static Future<void> clearRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('rememberMe');
    await prefs.remove('rememberedEmail');
    await prefs.remove('rememberedPassword');
  }

  // ✅ Clear session only
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('email');
    await prefs.remove('fullName');
    await prefs.remove('avatarUrl');
    await prefs.remove('role');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    // NOTE: Remember me data is NOT cleared here
  }

  // ✅ Clear all
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
