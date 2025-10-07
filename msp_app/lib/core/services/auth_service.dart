import 'package:msp_app/shared/entities/user.dart';
import 'package:msp_app/shared/mock_data/user_mock_data.dart';
import 'storage_service.dart';
import 'jwt_service.dart';

class AuthService {
  // Save authentication data
  static Future<void> saveAuthData(User user, String token) async {
    await StorageService.saveToken(token);
    await StorageService.saveUserData({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'role': user.role.name,
      'companyId': user.companyId,
      'avatar': user.avatar,
      'createdAt': user.createdAt.toIso8601String(),
      'isActive': user.isActive,
    });
    
    // Also save individual fields for compatibility with existing code
    await StorageService.saveString('userName', user.name);
    await StorageService.saveString('userEmail', user.email);
    await StorageService.saveString('userRole', user.roleDisplayName);
    await StorageService.saveString('organizationName', 'MSP Organization'); // Default organization
    
    await StorageService.setLoggedIn(true);
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final userData = await StorageService.getUserData();
    
    if (userData == null) return null;
    
    try {
      return User(
        id: userData['id'],
        email: userData['email'],
        name: userData['name'],
        role: UserRole.values.firstWhere((role) => role.name == userData['role']),
        companyId: userData['companyId'],
        avatar: userData['avatar'],
        createdAt: DateTime.parse(userData['createdAt']),
        isActive: userData['isActive'] ?? true,
        password: '', // Don't store password
      );
    } catch (e) {
      return null;
    }
  }

  // Get current token
  static Future<String?> getToken() async {
    return await StorageService.getToken();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }

  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    // This would normally call your API
    // For now, we'll use mock authentication
    final user = UserMockData.authenticateUser(email, password);
    
    if (user != null) {
      final token = JWTService.generateFakeJWT(user);
      await saveAuthData(user, token);
      
      return {
        'success': true,
        'user': user,
        'token': token,
      };
    } else {
      return {
        'success': false,
        'error': 'Invalid email or password',
      };
    }
  }

  // Logout user
  static Future<void> logout() async {
    await StorageService.clearAuthData();
  }

  // Get user role
  static Future<UserRole?> getUserRole() async {
    final user = await getCurrentUser();
    return user?.role;
  }

  // Check if token is expired
  static Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) return true;
    
    return JWTService.isTokenExpired(token);
  }

  // Get token info for debugging
  static Future<Map<String, dynamic>?> getTokenInfo() async {
    final token = await getToken();
    if (token == null) return null;
    
    return JWTService.getTokenInfo(token);
  }

  // Validate current session
  static Future<bool> validateSession() async {
    final loggedInStatus = await isLoggedIn();
    if (!loggedInStatus) return false;
    
    final token = await getToken();
    if (token == null) return false;
    
    return !JWTService.isTokenExpired(token);
  }
}
