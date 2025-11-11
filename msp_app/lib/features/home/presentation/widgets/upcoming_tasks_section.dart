import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/task.dart';

/// Task model for upcoming tasks
class UpcomingTask {
  final String id;
  final String title;
  final String projectName;
  final DateTime dueDate;
  final String priority; // high, medium, low
  final bool isOverdue;

  UpcomingTask({
    required this.id,
    required this.title,
    required this.projectName,
    required this.dueDate,
    required this.priority,
    required this.isOverdue,
  });
}

/// Upcoming Tasks Section - Hiển thị tasks sắp tới
class UpcomingTasksSection extends StatelessWidget {
  final List<UpcomingTask> upcomingTasks;
  final VoidCallback? onViewAll;

  const UpcomingTasksSection({
    Key? key,
    required this.upcomingTasks,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tasks sắp tới',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const ListTasksPage(),
              //       ),
              //     );
              //   },
              //   child: const Text('Xem tất cả'),
              // ),
            ],
          ),
          ...upcomingTasks.take(3).map((task) => _buildTaskItem(context, task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, UpcomingTask task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getPriorityIcon(task.priority),
            color: _getPriorityColor(task.priority),
            size: 20,
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.projectName,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: task.isOverdue ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDueDate(task.dueDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isOverdue ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: task.isOverdue
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'QUÁ HẠN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Convert UpcomingTask to Task entity for navigation
          final taskEntity = Task(
            id: task.id,
            title: task.title,
            description: 'Task từ upcoming tasks', // Default description
            assigneeId: 'user_001', // Default assignee ID
            assigneeName: 'Current User', // Default assignee name
            assigneeEmail: 'user@example.com', // Default assignee email
            assigneeAvatar: '👤', // Default assignee avatar
            startDate: DateTime.now().subtract(
              const Duration(days: 1),
            ), // Default start date
            dueDate: task.dueDate,
            status: 'In Progress', // Default status
            priority: task.priority,
            color: '#FF9800', // Default color (orange)
            projectName: task.projectName, // Project name from upcoming task
          );

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => TaskDetailPage(task: taskEntity),
          //   ),
          // );
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return Icons.error_outline;
      case 'medium':
        return Icons.warning_amber;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Ngày mai';
    } else if (difference.inDays > 1 && difference.inDays <= 7) {
      return '${difference.inDays} ngày nữa';
    } else {
      return '${dueDate.day}/${dueDate.month}';
    }
  }
}
