class UserTokenEntity {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final String fullName;
  final String avatarUrl;
  final String role;

  UserTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.role,
  });
}
