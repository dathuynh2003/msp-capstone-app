import 'package:flutter/material.dart';

/// Stats Cards Section - Hiển thị thống kê tasks
class StatsCardsSection extends StatelessWidget {
  final int assignedTasksCount;
  final int completedTasksCount;
  final int pendingTasksCount;

  const StatsCardsSection({
    Key? key,
    required this.assignedTasksCount,
    required this.completedTasksCount,
    required this.pendingTasksCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Assigned Tasks Card
          Expanded(
            child: _buildStatCard(
              'Tasks được giao',
              '$assignedTasksCount',
              Icons.task_alt,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          // Completed Tasks Card
          Expanded(
            child: _buildStatCard(
              'Đã hoàn thành',
              '$completedTasksCount',
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          // Pending Tasks Card
          Expanded(
            child: _buildStatCard(
              'Đang chờ',
              '$pendingTasksCount',
              Icons.pending_actions,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
