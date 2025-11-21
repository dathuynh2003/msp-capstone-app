import '../repositories/project_repository.dart';
import '../../data/models/get_project_response.dart';

class GetProjectsByUserUseCase {
  final ProjectRepository repository;
  GetProjectsByUserUseCase(this.repository);

  Future<List<GetProjectResponse>> call(String userId, String role) {
    return repository.getProjectsByUser(userId, role);
  }
}
