import '../../domain/entities/notification_entity.dart';

class NotificationModel {
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

  NotificationModel({
    required this.id,
    required this.userId,
    this.actorId,
    required this.title,
    required this.message,
    this.type,
    this.entityId,
    this.isRead = false,
    this.readAt,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      actorId: json['actorId'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String?,
      entityId: json['entityId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      data: json['data'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // To JSON
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

  // To Entity
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      actorId: actorId,
      title: title,
      message: message,
      type: type,
      entityId: entityId,
      isRead: isRead,
      readAt: readAt,
      data: data,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From Entity
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      actorId: entity.actorId,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      entityId: entity.entityId,
      isRead: entity.isRead,
      readAt: entity.readAt,
      data: entity.data,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
