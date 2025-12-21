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

  // ✅ Copy method for easier updates
  UserInfo copyWith({
    String? userId,
    String? userName,
    String? email,
    String? role,
    String? avatarUrl,
  }) => UserInfo(
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    email: email ?? this.email,
    role: role ?? this.role,
    avatarUrl: avatarUrl ?? this.avatarUrl,
  );
}

class UserProvider extends StateNotifier<UserInfo> {
  UserProvider() : super(UserInfo.empty());

  // ✅ REMOVED: Auto-load from constructor
  // AuthProvider will handle updates

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

  void clear() {
    state = UserInfo.empty();
  }
}

// ✅ FIXED: Remove auto-load on initialization
final userProvider = StateNotifierProvider<UserProvider, UserInfo>((ref) {
  return UserProvider();
  // AuthProvider will update this after login/session restore
});
