import 'package:msp_app/features/task/data/datasources/task_remote_datasource.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';
import 'package:msp_app/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDatasource remoteDatasource;

  TaskRepositoryImpl(this.remoteDatasource);

  @override
  Future<TaskDetailResponse> getTaskDetail(String taskId) {
    return remoteDatasource.getTaskDetailWithHistory(taskId);
  }
}
