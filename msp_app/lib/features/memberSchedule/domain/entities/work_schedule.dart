class WorkSchedule {
  final String id;
  final String userId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String type; // 'task', 'meeting'
  final String status; // Task: 'todo', 'ongoing', 'review', 'completed' | Meeting: 'scheduled', 'ongoing', 'finished'
  final String? notes;
  final List<String> tasks;
  final bool isWorkDay;

  const WorkSchedule({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.status,
    this.notes,
    this.tasks = const [],
    this.isWorkDay = true,
  });

  WorkSchedule copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? type,
    String? status,
    String? notes,
    List<String>? tasks,
    bool? isWorkDay,
  }) {
    return WorkSchedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      tasks: tasks ?? this.tasks,
      isWorkDay: isWorkDay ?? this.isWorkDay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'type': type,
      'status': status,
      'notes': notes,
      'tasks': tasks,
      'isWorkDay': isWorkDay,
    };
  }

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    return WorkSchedule(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      type: json['type'],
      status: json['status'],
      notes: json['notes'],
      tasks: List<String>.from(json['tasks'] ?? []),
      isWorkDay: json['isWorkDay'] ?? true,
    );
  }

  // Helper methods
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get timeRange {
    return '$startTime - $endTime';
  }

  Duration get workDuration {
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    return end.difference(start);
  }

  String get workDurationFormatted {
    final duration = workDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  bool get isPast {
    return date.isBefore(DateTime.now());
  }

  bool get isFuture {
    return date.isAfter(DateTime.now());
  }
}
