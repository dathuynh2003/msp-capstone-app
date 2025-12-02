import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/home/data/models/get_project_response.dart';
import 'package:msp_app/features/project/data/datasources/project_remote_datasource.dart';
import 'package:msp_app/features/project/data/repositories/project_repository_impl.dart';
import 'package:msp_app/features/project/domain/repositories/project_repository.dart';
import 'package:msp_app/features/project/domain/usecases/get_projects_by_user_usecase.dart';

// Datasource provider
final projectRemoteDatasourceProvider = Provider<ProjectRemoteDatasource>((
  ref,
) {
  return ProjectRemoteDatasource();
});

// Repository provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final datasource = ref.read(projectRemoteDatasourceProvider);
  return ProjectRepositoryImpl(datasource);
});

// UseCase provider
final getProjectsByUserUseCaseProvider = Provider<GetProjectsByUserUseCase>((
  ref,
) {
  final repository = ref.read(projectRepositoryProvider);
  return GetProjectsByUserUseCase(repository);
});

// Projects List Provider (auto-fetch based on userId and role)
final projectsListProvider =
    FutureProvider.family<List<GetProjectResponse>, ProjectsListParams>((
      ref,
      params,
    ) async {
      final useCase = ref.read(getProjectsByUserUseCaseProvider);
      return useCase.call(params.userId, params.role);
    });

// Params class
class ProjectsListParams {
  final String userId;
  final String role;

  ProjectsListParams({required this.userId, required this.role});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectsListParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          role == other.role;

  @override
  int get hashCode => userId.hashCode ^ role.hashCode;
}
