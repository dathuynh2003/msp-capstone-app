import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/home/domain/params/project_query_param.dart';
import '../../domain/usecases/get_projects_by_user_usecase.dart';
import '../../data/datasources/project_remote_datasource.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../data/models/get_project_response.dart';

// Provider setup
final projectRepositoryProvider = Provider(
  (ref) => ProjectRepositoryImpl(ProjectRemoteDatasource()),
);

final getProjectsByUserUseCaseProvider = Provider(
  (ref) => GetProjectsByUserUseCase(ref.watch(projectRepositoryProvider)),
);

final projectListProvider = FutureProvider.autoDispose
    .family<List<GetProjectResponse>, ProjectQueryParam>((ref, params) async {
      final useCase = ref.watch(getProjectsByUserUseCaseProvider);
      return useCase.call(params.userId, params.role);
    });
