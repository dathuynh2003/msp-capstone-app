class ProjectQueryParam {
  final String userId;
  final String role;

  const ProjectQueryParam({required this.userId, required this.role});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectQueryParam &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          role == other.role;

  @override
  int get hashCode => userId.hashCode ^ role.hashCode;
}
