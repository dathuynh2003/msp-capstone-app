import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/task/data/datasources/task_remote_datasource.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';
import 'package:msp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:msp_app/features/task/domain/repositories/task_repository.dart';
import 'package:msp_app/features/task/domain/usecases/get_task_detail_usecase.dart';

// Datasource Provider
final taskRemoteDatasourceProvider = Provider<TaskRemoteDatasource>((ref) {
  return TaskRemoteDatasource();
});

// Repository Provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final datasource = ref.watch(taskRemoteDatasourceProvider);
  return TaskRepositoryImpl(datasource);
});

// Use Case Provider
final getTaskDetailUsecaseProvider = Provider<GetTaskDetailUsecase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetTaskDetailUsecase(repository);
});

// Task Detail Provider
final taskDetailProvider = FutureProvider.family<TaskDetailResponse, String>((
  ref,
  taskId,
) async {
  final usecase = ref.watch(getTaskDetailUsecaseProvider);
  return usecase(taskId);
});
