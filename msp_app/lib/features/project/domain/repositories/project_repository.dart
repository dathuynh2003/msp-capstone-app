import 'package:msp_app/features/project/data/models/project_detail_response.dart';

abstract class ProjectRepository {
  Future<ProjectDetailResponse> getProjectDetailByUser({
    required String projectId,
    required String userId,
  });
}
