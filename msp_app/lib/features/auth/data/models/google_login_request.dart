class GoogleLoginRequest {
  final String idToken;
  final String googleId;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatarUrl;

  GoogleLoginRequest({
    required this.idToken,
    required this.googleId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'googleId': googleId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
    };
  }
}
