enum UserRole {
  adminSystem,
  businessOwner,
  projectManager,
  member,
}

class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final UserRole role;
  final String? companyId;
  final String? avatar;
  final DateTime createdAt;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.companyId,
    this.avatar,
    required this.createdAt,
    this.isActive = true,
  });

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    UserRole? role,
    String? companyId,
    String? avatar,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      role: role ?? this.role,
      companyId: companyId ?? this.companyId,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  String get roleDisplayName {
    switch (role) {
      case UserRole.adminSystem:
        return 'Quản Trị Hệ Thống';
      case UserRole.businessOwner:
        return 'Chủ Doanh Nghiệp';
      case UserRole.projectManager:
        return 'Quản Lý Dự án';
      case UserRole.member:
        return 'Thành Viên';
    }
  }

  String get roleDescription {
    switch (role) {
      case UserRole.adminSystem:
        return 'Truy cập và quản lý toàn hệ thống';
      case UserRole.businessOwner:
        return 'Quản lý và giám sát công ty';
      case UserRole.projectManager:
        return 'Quản lí dự án và nhân sự trong dự án';
      case UserRole.member:
        return 'Truy cập cơ bản của người dùng';
    }
  }
}
