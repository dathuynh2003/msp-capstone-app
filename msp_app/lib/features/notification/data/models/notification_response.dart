import 'package:flutter/foundation.dart';

class NotificationResponse {
  final String id;
  final String userId;
  final String? actorId;
  final String title;
  final String message;
  final String? type;
  final String? entityId;
  final bool isRead;
  final DateTime? readAt;
  final String? data;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationResponse({
    required this.id,
    required this.userId,
    this.actorId,
    required this.title,
    required this.message,
    this.type,
    this.entityId,
    required this.isRead,
    this.readAt,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id:
          json['id']?.toString() ??
          '', // ✅ FIXED: Handle null + convert to String
      userId: json['userId']?.toString() ?? '', // ✅ FIXED
      actorId: json['actorId']?.toString(),
      title: json['title']?.toString() ?? 'No title', // ✅ FIXED: Default value
      message: json['message']?.toString() ?? 'No message', // ✅ FIXED
      type: json['type']?.toString(),
      entityId: json['entityId']?.toString(),
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null ? _parseDateTime(json['readAt']) : null,
      data: json['data']?.toString(),
      createdAt:
          _parseDateTime(json['createdAt']) ??
          DateTime.now(), // ✅ FIXED: Fallback
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(), // ✅ FIXED
    );
  }

  // ✅ HELPER: Safe DateTime parsing
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        // Handle timestamp in milliseconds
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return null;
    } catch (e) {
      debugPrint('Error parsing DateTime: $value - $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'actorId': actorId,
      'title': title,
      'message': message,
      'type': type,
      'entityId': entityId,
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
