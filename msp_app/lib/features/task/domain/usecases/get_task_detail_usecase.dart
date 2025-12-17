import 'package:msp_app/features/task/data/models/task_detail_response.dart';
import 'package:msp_app/features/task/domain/repositories/task_repository.dart';

class GetTaskDetailUsecase {
  final TaskRepository repository;

  GetTaskDetailUsecase(this.repository);

  Future<TaskDetailResponse> call(String taskId) {
    return repository.getTaskDetail(taskId);
  }
}
