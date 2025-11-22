import 'package:msp_app/features/project/data/models/project_detail_response.dart';
import 'package:msp_app/features/project/domain/repositories/project_repository.dart';

class GetProjectDetailUsecase {
  final ProjectRepository repository;
  GetProjectDetailUsecase(this.repository);

  Future<ProjectDetailResponse> call({
    required String projectId,
    required String userId,
  }) => repository.getProjectDetailByUser(projectId: projectId, userId: userId);
}
