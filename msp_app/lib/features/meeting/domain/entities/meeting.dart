import 'package:flutter/material.dart';
import 'package:msp_app/features/meeting/domain/entities/project.dart';

class Meeting {
  final String id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'scheduled', 'ongoing', 'finished'
  final String creatorId;
  final String creatorName;
  final DateTime createdAt;
  final String projectId;
  final Project? project;
  final List<String> participantIds;
  final List<String> participantNames;
  final List<String> milestoneIds;
  final String? meetingLink;
  final String? notes;

  const Meeting({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.creatorId,
    required this.creatorName,
    required this.createdAt,
    required this.projectId,
    this.project,
    this.participantIds = const [],
    this.participantNames = const [],
    this.milestoneIds = const [],
    this.meetingLink,
    this.notes,
  });

  Meeting copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? creatorId,
    String? creatorName,
    DateTime? createdAt,
    String? projectId,
    Project? project,
    List<String>? participantIds,
    List<String>? participantNames,
    List<String>? milestoneIds,
    String? meetingLink,
    String? notes,
  }) {
    return Meeting(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      createdAt: createdAt ?? this.createdAt,
      projectId: projectId ?? this.projectId,
      project: project ?? this.project,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      milestoneIds: milestoneIds ?? this.milestoneIds,
      meetingLink: meetingLink ?? this.meetingLink,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'createdAt': createdAt.toIso8601String(),
      'projectId': projectId,
      'project': project?.toJson(),
      'participantIds': participantIds,
      'participantNames': participantNames,
      'milestoneIds': milestoneIds,
      'meetingLink': meetingLink,
      'notes': notes,
    };
  }

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      creatorId: json['creatorId'],
      creatorName: json['creatorName'],
      createdAt: DateTime.parse(json['createdAt']),
      projectId: json['projectId'],
      project: json['project'] != null ? Project.fromJson(json['project']) : null,
      participantIds: List<String>.from(json['participantIds'] ?? []),
      participantNames: List<String>.from(json['participantNames'] ?? []),
      milestoneIds: List<String>.from(json['milestoneIds'] ?? []),
      meetingLink: json['meetingLink'],
      notes: json['notes'],
    );
  }

  // Helper methods
  String get formattedStartTime {
    return '${startTime.day}/${startTime.month}/${startTime.year} ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }

  String get formattedEndTime {
    return '${endTime.day}/${endTime.month}/${endTime.year} ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  Duration get duration {
    return endTime.difference(startTime);
  }

  String get durationFormatted {
    final duration = this.duration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
           startTime.month == now.month &&
           startTime.day == now.day;
  }

  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  bool get isFuture {
    return startTime.isAfter(DateTime.now());
  }

  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  String get statusDisplayText {
    switch (status) {
      case 'scheduled':
        return 'Đã lên lịch';
      case 'ongoing':
        return 'Đang diễn ra';
      case 'finished':
        return 'Đã kết thúc';
      default:
        return 'Không xác định';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'scheduled':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'finished':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
