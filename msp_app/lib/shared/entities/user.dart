import 'package:equatable/equatable.dart';

enum UserRole { adminSystem, businessOwner, projectManager, member }

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? avatarUrl;
  final String? phoneNumber;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: _parseRole(json['role'] as String?),
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': _roleToString(role),
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
    };
  }

  static UserRole _parseRole(String? roleString) {
    switch (roleString?.toLowerCase()) {
      case 'member':
        return UserRole.member;
      case 'projectmanager':
      case 'project_manager':
        return UserRole.projectManager;
      case 'adminsystem':
      case 'admin_system':
        return UserRole.adminSystem;
      case 'businessowner':
      case 'business_owner':
        return UserRole.businessOwner;
      default:
        return UserRole.member;
    }
  }

  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.member:
        return 'member';
      case UserRole.projectManager:
        return 'projectManager';
      case UserRole.adminSystem:
        return 'adminSystem';
      case UserRole.businessOwner:
        return 'businessOwner';
    }
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    role,
    avatarUrl,
    phoneNumber,
  ];
}
