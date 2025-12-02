import 'package:msp_app/features/home/data/models/get_project_response.dart';
import 'package:msp_app/features/project/data/models/project_detail_response.dart';

abstract class ProjectRepository {
  Future<ProjectDetailResponse> getProjectDetailByUser({
    required String projectId,
    required String userId,
  });

  Future<List<GetProjectResponse>> getProjectsByUser(
    String userId,
    String role,
  );
}
