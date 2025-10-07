import 'package:flutter/material.dart';

class Meeting {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> participantIds;
  final List<String> participantNames;
  final String organizerId;
  final String organizerName;
  final String meetingLink;
  final String status; // 'scheduled', 'ongoing', 'completed', 'cancelled'
  final String meetingType; // 'online', 'offline', 'hybrid'
  final String location; // For offline meetings
  final String color; // Hex color string
  final String agenda;
  final List<String> attachments;

  const Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.participantIds,
    required this.participantNames,
    required this.organizerId,
    required this.organizerName,
    required this.meetingLink,
    required this.status,
    required this.meetingType,
    required this.location,
    required this.color,
    required this.agenda,
    this.attachments = const [],
  });

  Meeting copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? participantIds,
    List<String>? participantNames,
    String? organizerId,
    String? organizerName,
    String? meetingLink,
    String? status,
    String? meetingType,
    String? location,
    String? color,
    String? agenda,
    List<String>? attachments,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      meetingLink: meetingLink ?? this.meetingLink,
      status: status ?? this.status,
      meetingType: meetingType ?? this.meetingType,
      location: location ?? this.location,
      color: color ?? this.color,
      agenda: agenda ?? this.agenda,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'participantIds': participantIds,
      'participantNames': participantNames,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'meetingLink': meetingLink,
      'status': status,
      'meetingType': meetingType,
      'location': location,
      'color': color,
      'agenda': agenda,
      'attachments': attachments,
    };
  }

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      participantIds: List<String>.from(json['participantIds'] as List),
      participantNames: List<String>.from(json['participantNames'] as List),
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      meetingLink: json['meetingLink'] as String,
      status: json['status'] as String,
      meetingType: json['meetingType'] as String,
      location: json['location'] as String,
      color: json['color'] as String,
      agenda: json['agenda'] as String,
      attachments: List<String>.from(json['attachments'] as List? ?? []),
    );
  }

  // Helper methods
  Duration get duration => endTime.difference(startTime);
  
  bool get isUpcoming => startTime.isAfter(DateTime.now());
  
  bool get isOngoing => DateTime.now().isAfter(startTime) && DateTime.now().isBefore(endTime);
  
  bool get isCompleted => endTime.isBefore(DateTime.now());
  
  bool get canJoin {
    final now = DateTime.now();
    final fifteenMinutesBefore = startTime.subtract(const Duration(minutes: 15));
    return now.isAfter(fifteenMinutesBefore) && now.isBefore(endTime);
  }
  
  String get timeUntilStart {
    final now = DateTime.now();
    if (now.isAfter(startTime)) return 'Started';
    
    final difference = startTime.difference(now);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${difference.inMinutes}m';
    }
  }
  
  String get formattedStartTime {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }
  
  String get formattedDate {
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }
}
