import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/local/user_prefs.dart';

class UserInfo {
  final String userId;
  final String userName;
  final String email;
  final String role;
  final String avatarUrl;

  const UserInfo({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.avatarUrl,
  });

  factory UserInfo.empty() => const UserInfo(
    userId: "",
    userName: "User",
    email: "user@example.com",
    role: "Member",
    avatarUrl: "",
  );
}

class UserProvider extends StateNotifier<UserInfo> {
  UserProvider() : super(UserInfo.empty());

  Future<void> loadFromPrefs() async {
    final info = await UserPrefs.getUser();
    state = UserInfo(
      userId: info['userId'] ?? "",
      userName: info['fullName'] ?? "User",
      email: info['email'] ?? "user@example.com",
      role: info['role'] ?? "Member",
      avatarUrl: info['avatarUrl'] ?? "",
    );
  }

  Future<void> logout() async {
    await UserPrefs.clear();
    state = UserInfo.empty();
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserInfo>((ref) {
  final provider = UserProvider();
  // Tự động load từ prefs khi khởi tạo, hoặc gọi từ AuthWrapper/Login
  provider.loadFromPrefs();
  return provider;
});
