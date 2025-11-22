class ProjectDetailParams {
  final String projectId;
  final String userId;
  const ProjectDetailParams(this.projectId, this.userId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectDetailParams &&
          runtimeType == other.runtimeType &&
          projectId == other.projectId &&
          userId == other.userId;

  @override
  int get hashCode => projectId.hashCode ^ userId.hashCode;
}
