class GetUserResponse {
  final String id;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String role;

  GetUserResponse({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.role,
  });

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      GetUserResponse(
        id: json['id'],
        fullName: json['fullName'],
        email: json['email'],
        avatarUrl: json['avatarUrl'] ?? '',
        role: json['role'] ?? '',
      );
}

class GetProjectResponse {
  final String id;
  final String name;
  final String? description;
  final String? status;
  final GetUserResponse owner;
  final GetUserResponse createdBy;
  final String? ownerId;
  final String? createdById;
  final String? startDate;
  final String? endDate;

  GetProjectResponse({
    required this.id,
    required this.name,
    this.description,
    this.status,
    required this.owner,
    required this.createdBy,
    this.ownerId,
    this.createdById,
    this.startDate,
    this.endDate,
  });

  factory GetProjectResponse.fromJson(Map<String, dynamic> json) =>
      GetProjectResponse(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        status: json['status'],
        owner: GetUserResponse.fromJson(json['owner']),
        createdBy: GetUserResponse.fromJson(json['createdBy']),
        ownerId: json['ownerId'],
        createdById: json['createdById'],
        startDate: json['startDate'],
        endDate: json['endDate'],
      );
}
