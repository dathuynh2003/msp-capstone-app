import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'task_item_widget.dart';

/// Tasks Tab - Hiển thị danh sách tasks
class TasksTab extends StatelessWidget {
  final Project project;

  const TasksTab({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allTasks = project.milestones.expand((m) => m.tasks).toList();

    if (allTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.task,
                size: 48,
                color: Colors.blue.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có nhiệm vụ nào',
              style: TextStyle(
                fontSize: 16, 
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tạo nhiệm vụ đầu tiên để bắt đầu làm việc',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: allTasks.length,
      itemBuilder: (context, index) {
        final task = allTasks[index];
        return TaskItemWidget(project: project, task: task);
      },
    );
  }

}
