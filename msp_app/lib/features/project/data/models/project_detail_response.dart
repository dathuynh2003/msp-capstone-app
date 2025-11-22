class ProjectDetailResponse {
  final String projectId;
  final String name;
  final String? description;
  final String status;
  final String? startDate;
  final String? endDate;
  final UserDto owner;
  final UserDto projectManager;
  final List<ProjectMemberDto> members;
  final List<ProjectTaskDto> tasks;

  ProjectDetailResponse({
    required this.projectId,
    required this.name,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.owner,
    required this.projectManager,
    required this.members,
    required this.tasks,
  });

  factory ProjectDetailResponse.fromJson(Map<String, dynamic> json) =>
      ProjectDetailResponse(
        projectId: json['projectId'],
        name: json['name'],
        description: json['description'],
        status: json['status'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        owner: UserDto.fromJson(json['owner']),
        projectManager: UserDto.fromJson(json['projectManager']),
        members: (json['members'] as List<dynamic>)
            .map((e) => ProjectMemberDto.fromJson(e))
            .toList(),
        tasks: (json['tasks'] as List<dynamic>)
            .map((e) => ProjectTaskDto.fromJson(e))
            .toList(),
      );
}

class UserDto {
  final String userId;
  final String fullName;
  final String email;
  final String avatarUrl;

  UserDto({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
  });
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    userId: json['userId'],
    fullName: json['fullName'],
    email: json['email'],
    avatarUrl: json['avatarUrl'] ?? "",
  );
}

class ProjectMemberDto {
  final String memberId;
  final String fullName;
  final String email;
  final String avatarUrl;
  ProjectMemberDto({
    required this.memberId,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
  });
  factory ProjectMemberDto.fromJson(Map<String, dynamic> json) =>
      ProjectMemberDto(
        memberId: json['memberId'],
        fullName: json['fullName'],
        email: json['email'],
        avatarUrl: json['avatarUrl'] ?? "",
      );
}

class ProjectTaskDto {
  final String taskId;
  final String title;
  final String? description;
  final String status;
  final String? startDate;
  final String? endDate;
  final bool isOverdue;
  final UserDto? assignee;

  ProjectTaskDto({
    required this.taskId,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.isOverdue,
    required this.assignee,
  });

  factory ProjectTaskDto.fromJson(Map<String, dynamic> json) => ProjectTaskDto(
    taskId: json['taskId'],
    title: json['title'],
    description: json['description'],
    status: json['status'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    isOverdue: json['isOverdue'] ?? false,
    assignee: json['assignee'] != null
        ? UserDto.fromJson(json['assignee'])
        : null,
  );
}
