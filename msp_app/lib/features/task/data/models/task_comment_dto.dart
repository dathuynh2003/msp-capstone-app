class TaskCommentDto {
  final String id;
  final String taskId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TaskCommentUserDto? user;

  TaskCommentDto({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory TaskCommentDto.fromJson(Map<String, dynamic> json) {
    return TaskCommentDto(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] != null
          ? TaskCommentUserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TaskCommentUserDto {
  final String id;
  final String email;
  final String fullName;
  final String avatarUrl;
  final String role;

  TaskCommentUserDto({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.role,
  });

  factory TaskCommentUserDto.fromJson(Map<String, dynamic> json) {
    return TaskCommentUserDto(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
