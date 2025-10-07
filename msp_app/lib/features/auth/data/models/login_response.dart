import 'package:msp_app/shared/entities/user.dart';

class LoginResponseModel {
  final String token;

  LoginResponseModel({required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(token: json['token']);
  }

  User toEntity() => User(
    id: '1',
    email: 'user@example.com',
    password: '',
    name: 'User',
    role: UserRole.member,
    createdAt: DateTime.now(),
  );
}
