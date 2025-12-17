class TaskDetailResponse {
  final String id;
  final String projectId;
  final String? userId;
  final String? reviewerId;
  final String title;
  final String? description;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isOverdue;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TaskUserDto? user;
  final TaskUserDto? reviewer;
  final List<TaskMilestoneDto> milestones;
  final List<TaskHistoryDto> taskHistories;

  TaskDetailResponse({
    required this.id,
    required this.projectId,
    this.userId,
    this.reviewerId,
    required this.title,
    this.description,
    required this.status,
    this.startDate,
    this.endDate,
    required this.isOverdue,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.reviewer,
    this.milestones = const [],
    this.taskHistories = const [],
  });

  factory TaskDetailResponse.fromJson(Map<String, dynamic> json) {
    return TaskDetailResponse(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      userId: json['userId'] as String?,
      reviewerId: json['reviewerId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isOverdue: json['isOverdue'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] != null
          ? TaskUserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      reviewer: json['reviewer'] != null
          ? TaskUserDto.fromJson(json['reviewer'] as Map<String, dynamic>)
          : null,
      milestones: json['milestones'] != null
          ? (json['milestones'] as List)
                .map(
                  (e) => TaskMilestoneDto.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
      taskHistories: json['taskHistories'] != null
          ? (json['taskHistories'] as List)
                .map((e) => TaskHistoryDto.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}

class TaskUserDto {
  final String id;
  final String userName;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String avatarUrl;
  final String role;
  final DateTime createdAt;

  TaskUserDto({
    required this.id,
    required this.userName,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.role,
    required this.createdAt,
  });

  factory TaskUserDto.fromJson(Map<String, dynamic> json) {
    return TaskUserDto(
      id: json['id'] as String,
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      role: json['role'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class TaskMilestoneDto {
  final String id;
  final String projectId;
  final String name;
  final DateTime? dueDate;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskMilestoneDto({
    required this.id,
    required this.projectId,
    required this.name,
    this.dueDate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskMilestoneDto.fromJson(Map<String, dynamic> json) {
    return TaskMilestoneDto(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class TaskHistoryDto {
  final String id;
  final String taskId;
  final String? fromUserId;
  final String? toUserId;
  final String action;
  final String changedById;
  final String? fieldName;
  final String? oldValue;
  final String? newValue;
  final DateTime createdAt;
  final TaskUserDto? fromUser;
  final TaskUserDto? toUser;
  final TaskUserDto? changedBy;

  TaskHistoryDto({
    required this.id,
    required this.taskId,
    this.fromUserId,
    this.toUserId,
    required this.action,
    required this.changedById,
    this.fieldName,
    this.oldValue,
    this.newValue,
    required this.createdAt,
    this.fromUser,
    this.toUser,
    this.changedBy,
  });

  factory TaskHistoryDto.fromJson(Map<String, dynamic> json) {
    return TaskHistoryDto(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      fromUserId: json['fromUserId'] as String?,
      toUserId: json['toUserId'] as String?,
      action: json['action'] as String,
      changedById: json['changedById'] as String,
      fieldName: json['fieldName'] as String?,
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      fromUser: json['fromUser'] != null
          ? TaskUserDto.fromJson(json['fromUser'] as Map<String, dynamic>)
          : null,
      toUser: json['toUser'] != null
          ? TaskUserDto.fromJson(json['toUser'] as Map<String, dynamic>)
          : null,
      changedBy: json['changedBy'] != null
          ? TaskUserDto.fromJson(json['changedBy'] as Map<String, dynamic>)
          : null,
    );
  }

  String get changeDescription {
    switch (action) {
      case 'Created':
        return 'Created task';
      case 'Assigned':
        return 'Assigned to ${toUser?.fullName ?? "N/A"}';
      case 'Reassigned':
        return 'Reassigned from ${fromUser?.fullName ?? "N/A"} to ${toUser?.fullName ?? "N/A"}';
      case 'StatusChanged':
        return 'Changed status from "$oldValue" to "$newValue"';
      case 'Updated':
        if (fieldName == 'Title') {
          return 'Changed title from "$oldValue" to "$newValue"';
        } else if (fieldName == 'Description') {
          return 'Updated description';
        } else if (fieldName == 'StartDate') {
          return 'Changed start date from $oldValue to $newValue';
        } else if (fieldName == 'EndDate') {
          return 'Changed deadline from $oldValue to $newValue';
        } else {
          return 'Updated $fieldName';
        }
      default:
        return 'Changed';
    }
  }
}
