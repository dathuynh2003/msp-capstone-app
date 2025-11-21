import '../models/get_project_response.dart';
import '../datasources/project_remote_datasource.dart';
import '../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDatasource remoteDatasource;

  ProjectRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<GetProjectResponse>> getProjectsByUser(
    String userId,
    String role,
  ) async {
    if (role == "Manager") {
      return remoteDatasource.getProjectsByManagerId(userId);
    } else {
      return remoteDatasource.getProjectsByMemberId(userId);
    }
  }
}
