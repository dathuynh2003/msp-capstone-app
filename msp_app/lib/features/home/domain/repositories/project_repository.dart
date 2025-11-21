import '../../data/models/get_project_response.dart';

abstract class ProjectRepository {
  Future<List<GetProjectResponse>> getProjectsByUser(
    String userId,
    String role,
  );
}
