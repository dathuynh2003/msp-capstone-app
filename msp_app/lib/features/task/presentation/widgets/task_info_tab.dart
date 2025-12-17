import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';

const Color pastelCream = Color(0xFFFFF5ED);

class TaskInfoTab extends StatelessWidget {
  final TaskDetailResponse task;
  final Color statusColor; // ✅ Add statusColor

  const TaskInfoTab({super.key, required this.task, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      children: [
        // Assignee - Always show
        _buildInfoCard(
          icon: Icons.person,
          label: 'Assignee',
          child: task.user != null
              ? _buildUserCard(task.user!)
              : _buildEmptyState('No assignee assigned'),
        ),

        const SizedBox(height: 16),

        // Reviewer - Always show
        _buildInfoCard(
          icon: Icons.rate_review,
          label: 'Reviewer',
          child: task.reviewer != null
              ? _buildUserCard(task.reviewer!)
              : _buildEmptyState('No reviewer assigned'),
        ),

        const SizedBox(height: 16),

        // Timeline Card
        _buildTimelineCard(task),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3), // ✅ Status color
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1), // ✅ Status color
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15), // ✅ Status color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: statusColor,
                ), // ✅ Status color
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildUserCard(TaskUserDto user) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08), // ✅ Status color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.2), // ✅ Status color
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2), // ✅ Status color
              shape: BoxShape.circle,
              image: user.avatarUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(user.avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: user.avatarUrl.isEmpty
                ? Icon(
                    Icons.person,
                    size: 24,
                    color: statusColor,
                  ) // ✅ Status color
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(TaskDetailResponse task) {
    final hasOverdue = task.isOverdue;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3), // ✅ Status color
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1), // ✅ Status color
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15), // ✅ Status color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: statusColor, // ✅ Status color
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Timeline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (hasOverdue)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    'OVERDUE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // ✅ Start Date & End Date - Always show with placeholders
          Row(
            children: [
              Expanded(
                child: _buildDateItem(
                  Icons.play_arrow,
                  'Start Date',
                  task.startDate != null
                      ? DateFormat('dd/MM/yyyy').format(task.startDate!)
                      : '--/--/----',
                  false,
                  task.startDate == null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateItem(
                  Icons.flag,
                  'End Date',
                  task.endDate != null
                      ? DateFormat('dd/MM/yyyy').format(task.endDate!)
                      : '--/--/----',
                  task.isOverdue && task.endDate != null,
                  task.endDate == null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            color: statusColor.withOpacity(0.3),
            height: 1,
          ), // ✅ Status color

          const SizedBox(height: 16),

          // ✅ Created & Last Updated
          Row(
            children: [
              Expanded(
                child: _buildDateItem(
                  Icons.access_time,
                  'Created',
                  DateFormat('dd/MM/yyyy HH:mm').format(task.createdAt),
                  false,
                  false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateItem(
                  Icons.update,
                  'Last Updated',
                  DateFormat('dd/MM/yyyy HH:mm').format(task.updatedAt),
                  false,
                  false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(
    IconData icon,
    String label,
    String value,
    bool isOverdue,
    bool isEmpty,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isOverdue
              ? Colors.red
              : isEmpty
              ? Colors.grey[400]
              : statusColor, // ✅ Status color
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isOverdue
                      ? Colors.red
                      : isEmpty
                      ? Colors.grey[400]
                      : Colors.black87,
                  fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
