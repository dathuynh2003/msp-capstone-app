// Models for PM Dashboard
class TeamMember {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final int assignedTasks;
  final double performance;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.assignedTasks,
    required this.performance,
  });
}

class Meeting {
  final String id;
  final String title;
  final String description;
  final String projectName;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final List<String> attendees;

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.attendees,
  });
}

class ProjectAlert {
  final String id;
  final String type; // overdue, resource, progress, planning
  final String title;
  final String description;
  final String projectName;
  final DateTime createdAt;
  final String severity; // high, medium, low

  ProjectAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.projectName,
    required this.createdAt,
    required this.severity,
  });
}
