import 'package:msp_app/features/task/data/models/task_detail_response.dart';

abstract class TaskRepository {
  Future<TaskDetailResponse> getTaskDetail(String taskId);
}
