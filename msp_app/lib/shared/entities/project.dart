import 'milestone.dart';
import 'meeting.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String status;
  final String priority;
  final String timeline;
  final String projectManager;
  final int progress;
  final DateTime startDate;
  final DateTime endDate;
  final List<Milestone> milestones;
  final List<Meeting> meetings;
  final String icon;
  final String color;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.priority,
    required this.timeline,
    required this.projectManager,
    required this.progress,
    required this.startDate,
    required this.endDate,
    this.milestones = const [],
    this.meetings = const [],
    required this.icon,
    required this.color,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    String? priority,
    String? timeline,
    String? projectManager,
    int? progress,
    DateTime? startDate,
    DateTime? endDate,
    List<Milestone>? milestones,
    List<Meeting>? meetings,
    String? icon,
    String? color,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      timeline: timeline ?? this.timeline,
      projectManager: projectManager ?? this.projectManager,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      milestones: milestones ?? this.milestones,
      meetings: meetings ?? this.meetings,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'priority': priority,
      'timeline': timeline,
      'projectManager': projectManager,
      'progress': progress,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'milestones': milestones.map((milestone) => milestone.toJson()).toList(),
      'meetings': meetings.map((meeting) => meeting.toJson()).toList(),
      'icon': icon,
      'color': color,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      timeline: json['timeline'],
      projectManager: json['projectManager'],
      progress: json['progress'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      milestones: (json['milestones'] as List<dynamic>?)
          ?.map((milestone) => Milestone.fromJson(milestone))
          .toList() ?? [],
      meetings: (json['meetings'] as List<dynamic>?)
          ?.map((meeting) => Meeting.fromJson(meeting))
          .toList() ?? [],
      icon: json['icon'],
      color: json['color'],
    );
  }
}
