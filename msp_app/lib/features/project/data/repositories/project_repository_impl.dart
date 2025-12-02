import 'package:msp_app/features/home/data/models/get_project_response.dart';
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

  @override
  Future<List<GetProjectResponse>> getProjectsByUser(
    String userId,
    String role,
  ) async {
    // Gọi endpoint phù hợp dựa trên role
    if (role.toLowerCase() == 'manager' ||
        role.toLowerCase() == 'businessowner') {
      return remoteDatasource.getProjectsByManagerId(userId);
    } else {
      return remoteDatasource.getProjectsByMemberId(userId);
    }
  }
}
