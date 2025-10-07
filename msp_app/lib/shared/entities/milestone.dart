import 'task.dart';

/// Milestone entity
class Milestone {
  final String id;
  final String title;
  final String description;
  final String status; // Planning, In Progress, Completed, On Hold
  final DateTime startDate;
  final DateTime dueDate;
  final int progress; // 0-100
  final String priority; // High, Medium, Low
  final List<Task> tasks;
  final String color;
  final String? projectName; // Tên project mà milestone thuộc về

  const Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.dueDate,
    required this.progress,
    required this.priority,
    required this.tasks,
    required this.color,
    this.projectName,
  });

  Milestone copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    DateTime? startDate,
    DateTime? dueDate,
    int? progress,
    String? priority,
    List<Task>? tasks,
    String? color,
    String? projectName,
  }) {
    return Milestone(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      progress: progress ?? this.progress,
      priority: priority ?? this.priority,
      tasks: tasks ?? this.tasks,
      color: color ?? this.color,
      projectName: projectName ?? this.projectName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'progress': progress,
      'priority': priority,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'color': color,
      'projectName': projectName,
    };
  }

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      progress: json['progress'] as int,
      priority: json['priority'] as String,
      tasks: (json['tasks'] as List)
          .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
          .toList(),
      color: json['color'] as String,
      projectName: json['projectName'] as String?,
    );
  }
}
