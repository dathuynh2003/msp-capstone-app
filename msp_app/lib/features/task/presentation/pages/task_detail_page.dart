import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/task.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'package:msp_app/core/permissions/permission_manager.dart';
import 'package:msp_app/features/project/presentation/widgets/task_dialogs.dart';

/// Task Detail Page - Chi tiết task
class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  
  // Mock comments data
  final List<Map<String, dynamic>> _mockComments = [
    {
      'userName': 'Nguyễn Văn A',
      'content': 'Tôi đã hoàn thành phần backend API cho task này. Cần review code không?',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'avatar': '👨‍💻',
    },
    {
      'userName': 'Trần Thị B',
      'content': 'UI design đã được cập nhật theo yêu cầu mới. File design đã upload lên Figma.',
      'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
      'avatar': '👩‍🎨',
    },
    {
      'userName': 'Lê Văn C',
      'content': 'Test case đã được viết xong. Sẽ chạy test vào cuối tuần này.',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'avatar': '👨‍🔬',
    },
    {
      'userName': 'Phạm Thị D',
      'content': 'Task này có vẻ phức tạp hơn dự kiến. Có thể cần thêm 2 ngày để hoàn thành.',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'avatar': '👩‍💼',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        backgroundColor: Colors.orange, // Màu cam chủ đạo
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<bool>(
            future: PermissionManager.isProjectManager(),
            builder: (context, snapshot) {
              final isPM = snapshot.data == true;
              // For members (not PM), still show Update Status
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'update_status':
                      TaskDialogs.showUpdateTaskStatusDialog(context, widget.task);
                      break;
                    case 'update':
                      if (isPM) {
                        // Create a mock project from task's projectName
                        final mockProject = Project(
                          id: 'mock-project-id',
                          name: widget.task.projectName ?? 'Unknown Project',
                          description: 'Project for task: ${widget.task.title}',
                          status: 'Active',
                          priority: 'High',
                          timeline: '3 months',
                          projectManager: 'Project Manager',
                          progress: 50,
                          startDate: DateTime.now().subtract(const Duration(days: 30)),
                          endDate: DateTime.now().add(const Duration(days: 30)),
                          icon: '📋',
                          color: 'orange',
                        );
                        TaskDialogs.showUpdateTaskDialog(context, mockProject, widget.task);
                      }
                      break;
                    case 'delete':
                      if (isPM) {
                        TaskDialogs.showDeleteTaskDialog(context, widget.task);
                      }
                      break;
                  }
                },
                itemBuilder: (context) {
                  final items = <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'update_status',
                      child: Row(
                        children: [
                          Icon(Icons.update, color: Colors.blue, size: 18),
                          SizedBox(width: 8),
                          Text('Cập nhật trạng thái'),
                        ],
                      ),
                    ),
                  ];
                  if (isPM) {
                    items.addAll([
                      const PopupMenuItem<String>(
                        value: 'update',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.orange, size: 18),
                            SizedBox(width: 8),
                            Text('Cập nhật nhiệm vụ'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Text('Xóa nhiệm vụ'),
                          ],
                        ),
                      ),
                    ]);
                  }
                  return items;
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Header Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade400, Colors.orange.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.task_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.task.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.task.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Project Info Card
                  _buildInfoCard(
                    'Dự án',
                    widget.task.projectName ?? 'Chưa xác định',
                    Icons.folder,
                    Colors.purple,
                  ),
                  const SizedBox(height: 8),

                  // Task Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Người thực hiện',
                          widget.task.assigneeName,
                          Icons.person,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoCard(
                          'Ngày hết hạn',
                          '${widget.task.dueDate.day}/${widget.task.dueDate.month}/${widget.task.dueDate.year}',
                          Icons.schedule,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Trạng thái',
                          widget.task.status.isNotEmpty ? widget.task.status : 'In Progress',
                          Icons.info,
                          _getStatusColor(widget.task.status.isNotEmpty ? widget.task.status : 'in progress'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoCard(
                          'Độ ưu tiên',
                          widget.task.priority.isNotEmpty ? widget.task.priority : 'High',
                          Icons.priority_high,
                          _getPriorityColor(widget.task.priority.isNotEmpty ? widget.task.priority : 'high'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Comments Section
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bình luận (${_mockComments.length})',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._mockComments.map((comment) => CommentItem(comment: comment)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add Comment Section
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Thêm bình luận...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bình luận đã được thêm')),
                      );
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.05),
            color.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade600;
      case 'in progress':
        return Colors.orange.shade600;
      case 'todo':
        return Colors.grey.shade600;
      case 'done':
        return Colors.green.shade600;
      case 'pending':
        return Colors.amber.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade600;
      case 'medium':
        return Colors.orange.shade600;
      case 'low':
        return Colors.green.shade600;
      case 'urgent':
        return Colors.purple.shade600;
      case 'normal':
        return Colors.blue.shade600;
      default:
        return Colors.blue.shade600;
    }
  }
}

/// Comment Item Widget - Hiển thị một comment
class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange.withValues(alpha: 0.1),
                radius: 14,
                child: Text(
                  comment['avatar'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['userName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _formatDateTime(comment['createdAt']),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment['content'],
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
