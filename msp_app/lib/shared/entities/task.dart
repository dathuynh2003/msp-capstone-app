/// Task entity với thông tin member assignee
class Task {
  final String id;
  final String title;
  final String description;
  final String status; // Pending, In Progress, Completed, On Hold
  final String priority; // High, Medium, Low
  final DateTime startDate;
  final DateTime dueDate;
  final String assigneeId; // ID của member được assign
  final String assigneeName; // Tên của member
  final String assigneeEmail; // Email của member
  final String assigneeAvatar; // Avatar URL của member
  final String color;
  final String? projectName; // Tên project mà task thuộc về
  final int estimatedHours; // Số giờ ước tính
  final int actualHours; // Số giờ thực tế

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.dueDate,
    required this.assigneeId,
    required this.assigneeName,
    required this.assigneeEmail,
    required this.assigneeAvatar,
    required this.color,
    this.projectName,
    this.estimatedHours = 0,
    this.actualHours = 0,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? startDate,
    DateTime? dueDate,
    String? assigneeId,
    String? assigneeName,
    String? assigneeEmail,
    String? assigneeAvatar,
    String? color,
    String? projectName,
    int? estimatedHours,
    int? actualHours,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      assigneeEmail: assigneeEmail ?? this.assigneeEmail,
      assigneeAvatar: assigneeAvatar ?? this.assigneeAvatar,
      color: color ?? this.color,
      projectName: projectName ?? this.projectName,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'startDate': startDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'assigneeId': assigneeId,
      'assigneeName': assigneeName,
      'assigneeEmail': assigneeEmail,
      'assigneeAvatar': assigneeAvatar,
      'color': color,
      'projectName': projectName,
      'estimatedHours': estimatedHours,
      'actualHours': actualHours,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      assigneeId: json['assigneeId'] as String,
      assigneeName: json['assigneeName'] as String,
      assigneeEmail: json['assigneeEmail'] as String,
      assigneeAvatar: json['assigneeAvatar'] as String,
      color: json['color'] as String,
      projectName: json['projectName'] as String?,
      estimatedHours: json['estimatedHours'] as int? ?? 0,
      actualHours: json['actualHours'] as int? ?? 0,
    );
  }
}
