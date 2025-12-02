import 'package:msp_app/features/home/data/models/get_project_response.dart';
import 'package:msp_app/features/project/domain/repositories/project_repository.dart';

class GetProjectsByUserUseCase {
  final ProjectRepository repository;
  GetProjectsByUserUseCase(this.repository);

  Future<List<GetProjectResponse>> call(String userId, String role) {
    return repository.getProjectsByUser(userId, role);
  }
}
