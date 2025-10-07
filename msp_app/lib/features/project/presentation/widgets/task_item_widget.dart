import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'package:msp_app/core/permissions/permission_manager.dart';
import 'package:msp_app/features/task/presentation/pages/task_detail_page.dart';
import 'task_dialogs.dart';

/// Widget for displaying individual task items with permission-based actions
class TaskItemWidget extends StatelessWidget {
  final Project project;
  final dynamic task;

  const TaskItemWidget({
    Key? key,
    required this.project,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailPage(task: task),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTaskColor(task.priority),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _getTaskColor(task.priority).withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.task_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    _buildStatusChip(task.status),
                    const SizedBox(width: 8),
                    _buildActionMenu(context),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Info Row
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildInfoChip(
                      Icons.person,
                      'Người thực hiện: ${task.assigneeName}',
                      Colors.blue,
                    ),
                    _buildInfoChip(
                      Icons.schedule,
                      'Hạn: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                      Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Footer Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getTaskColor(task.priority).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ưu tiên: ${task.priority}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getTaskColor(task.priority),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return FutureBuilder<bool>(
      future: PermissionManager.isProjectManager(),
      builder: (context, snapshot) {
        final isProjectManager = snapshot.data == true;
        
        if (!isProjectManager) {
          // Member can only update status
          return FutureBuilder<bool>(
            future: PermissionManager.isMember(),
            builder: (context, memberSnapshot) {
              if (memberSnapshot.data == true) {
                return PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.blue.shade700, size: 18),
                  onSelected: (value) {
                    if (value == 'update_status') {
                      TaskDialogs.showUpdateTaskStatusDialog(context, task);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'update_status',
                      child: Row(
                        children: [
                          Icon(Icons.update, color: Colors.blue, size: 16),
                          SizedBox(width: 8),
                          Text('Cập nhật trạng thái', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          );
        }
        
        // Project Manager can do full CRUD
        return PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.blue.shade700, size: 18),
          onSelected: (value) {
            switch (value) {
              case 'update':
                TaskDialogs.showUpdateTaskDialog(context, project, task);
                break;
              case 'update_status':
                TaskDialogs.showUpdateTaskStatusDialog(context, task);
                break;
              case 'delete':
                TaskDialogs.showDeleteTaskDialog(context, task);
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(
              value: 'update',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue, size: 16),
                  SizedBox(width: 8),
                  Text('Cập nhật', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'update_status',
              child: Row(
                children: [
                  Icon(Icons.update, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Text('Cập nhật trạng thái', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text('Xóa', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTaskColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.orange; // Màu cam chủ đạo
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.orange; // Màu cam chủ đạo
    }
  }
}
