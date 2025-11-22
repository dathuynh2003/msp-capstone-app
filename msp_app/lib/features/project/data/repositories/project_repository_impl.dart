import 'package:msp_app/features/project/data/datasources/project_remote_datasource.dart';
import 'package:msp_app/features/project/domain/repositories/project_repository.dart';

import '../models/project_detail_response.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDatasource remoteDatasource;
  ProjectRepositoryImpl(this.remoteDatasource);

  @override
  Future<ProjectDetailResponse> getProjectDetailByUser({
    required String projectId,
    required String userId,
  }) {
    return remoteDatasource.getProjectDetailByUser(
      projectId: projectId,
      userId: userId,
    );
  }
}
