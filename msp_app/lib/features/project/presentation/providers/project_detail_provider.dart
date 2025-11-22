import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/project/data/datasources/project_remote_datasource.dart';
import 'package:msp_app/features/project/data/models/project_detail_response.dart';
import 'package:msp_app/features/project/data/repositories/project_repository_impl.dart';
import 'package:msp_app/features/project/domain/params/project_detail_params.dart';
import 'package:msp_app/features/project/domain/repositories/project_repository.dart';
import 'package:msp_app/features/project/domain/usecases/get_project_detail_usecase.dart';

// Provider cho repository
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepositoryImpl(ProjectRemoteDatasource());
});

// Provider cho usecase
final getProjectDetailUsecaseProvider = Provider<GetProjectDetailUsecase>((
  ref,
) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjectDetailUsecase(repo);
});

// Provider cho UI/fetch
final projectDetailProvider =
    FutureProvider.family<ProjectDetailResponse, ProjectDetailParams>((
      ref,
      params,
    ) {
      final usecase = ref.watch(getProjectDetailUsecaseProvider);
      return usecase(projectId: params.projectId, userId: params.userId);
    });
