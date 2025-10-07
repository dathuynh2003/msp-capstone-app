class Project {
  final String id;
  final String name;
  final String description;
  final String status; // 'planning', 'in_progress', 'completed', 'on_hold'
  final DateTime startDate;
  final DateTime? endDate;
  final String managerId;
  final String managerName;
  final List<String> memberIds;
  final List<String> memberNames;
  final List<Milestone> milestones;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.managerId,
    required this.managerName,
    this.memberIds = const [],
    this.memberNames = const [],
    this.milestones = const [],
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? managerId,
    String? managerName,
    List<String>? memberIds,
    List<String>? memberNames,
    List<Milestone>? milestones,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      memberIds: memberIds ?? this.memberIds,
      memberNames: memberNames ?? this.memberNames,
      milestones: milestones ?? this.milestones,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'managerId': managerId,
      'managerName': managerName,
      'memberIds': memberIds,
      'memberNames': memberNames,
      'milestones': milestones.map((m) => m.toJson()).toList(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      managerId: json['managerId'],
      managerName: json['managerName'],
      memberIds: List<String>.from(json['memberIds'] ?? []),
      memberNames: List<String>.from(json['memberNames'] ?? []),
      milestones: (json['milestones'] as List?)
          ?.map((m) => Milestone.fromJson(m))
          .toList() ?? [],
    );
  }

  // Helper methods
  String get statusDisplayText {
    switch (status) {
      case 'planning':
        return 'Đang lập kế hoạch';
      case 'in_progress':
        return 'Đang thực hiện';
      case 'completed':
        return 'Đã hoàn thành';
      case 'on_hold':
        return 'Tạm dừng';
      default:
        return 'Không xác định';
    }
  }

  String get formattedStartDate {
    return '${startDate.day}/${startDate.month}/${startDate.year}';
  }

  String? get formattedEndDate {
    if (endDate == null) return null;
    return '${endDate!.day}/${endDate!.month}/${endDate!.year}';
  }
}

class Milestone {
  final String id;
  final String name;
  final String description;
  final String status; // 'not_started', 'in_progress', 'completed'
  final DateTime? dueDate;
  final DateTime? completedDate;

  const Milestone({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.dueDate,
    this.completedDate,
  });

  Milestone copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    DateTime? dueDate,
    DateTime? completedDate,
  }) {
    return Milestone(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'dueDate': dueDate?.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
    };
  }

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
    );
  }

  // Helper methods
  String get statusDisplayText {
    switch (status) {
      case 'not_started':
        return 'Chưa bắt đầu';
      case 'in_progress':
        return 'Đang thực hiện';
      case 'completed':
        return 'Đã hoàn thành';
      default:
        return 'Không xác định';
    }
  }

  String? get formattedDueDate {
    if (dueDate == null) return null;
    return '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
  }

  String? get formattedCompletedDate {
    if (completedDate == null) return null;
    return '${completedDate!.day}/${completedDate!.month}/${completedDate!.year}';
  }
}
