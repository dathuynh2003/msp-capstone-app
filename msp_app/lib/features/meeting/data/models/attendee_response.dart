class AttendeeResponse {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;

  AttendeeResponse({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
  });

  factory AttendeeResponse.fromJson(Map<String, dynamic> json) =>
      AttendeeResponse(
        id: json['id'] as String,
        email: json['email'] ?? '',
        fullName: json['fullName'] ?? '',
        avatarUrl: json['avatarUrl'],
      );
}
