import 'package:flutter/material.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';
import 'package:msp_app/features/project/presentation/utils/task_status_helper.dart';

class TaskDetailHeader extends StatelessWidget {
  final TaskDetailResponse task;

  const TaskDetailHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final statusColor = TaskStatusHelper.getTaskStatusColor(task.status);
    final statusLabel = TaskStatusHelper.getStatusLabel(task.status);
    final statusIcon = TaskStatusHelper.getStatusIcon(task.status);

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // ✅ Add status color border
        border: Border.all(color: statusColor.withOpacity(0.3), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.20),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        // ✅ Add status color gradient background
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withOpacity(0.10),
              statusColor.withOpacity(0.10),
              statusColor.withOpacity(0.10),
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Title & Status Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Status Color Bar
                Container(
                  width: 5,
                  height: 60,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),

                const SizedBox(width: 14),

                // Title - Left
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ✅ Status Badge - Right
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: statusColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ✅ Description
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 19),
                child: Text(
                  task.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
