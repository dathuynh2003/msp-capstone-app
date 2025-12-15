class NotificationEntity {
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

  const NotificationEntity({
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

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? actorId,
    String? title,
    String? message,
    String? type,
    String? entityId,
    bool? isRead,
    DateTime? readAt,
    String? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      actorId: actorId ?? this.actorId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      entityId: entityId ?? this.entityId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
