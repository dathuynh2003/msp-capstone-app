import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';

class TaskMilestoneTab extends StatelessWidget {
  final List<TaskMilestoneDto> milestones;
  final Color statusColor; // ✅ Add statusColor

  const TaskMilestoneTab({
    super.key,
    required this.milestones,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15), // ✅ Status color
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flag_circle_outlined,
                size: 64,
                color: statusColor, // ✅ Status color
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Milestones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This task has no milestones yet.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final milestone = milestones[index];
        final isOverdue =
            milestone.dueDate != null &&
            milestone.dueDate!.isBefore(DateTime.now());

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOverdue
                  ? Colors.red.withOpacity(0.3)
                  : statusColor.withOpacity(0.3), // ✅ Status color
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isOverdue
                    ? Colors.red.withOpacity(0.1)
                    : statusColor.withOpacity(0.1), // ✅ Status color
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
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOverdue
                          ? Colors.red
                          : statusColor, // ✅ Status color
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      milestone.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              if (milestone.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Text(
                    milestone.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
              if (milestone.dueDate != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: isOverdue
                            ? Colors.red
                            : statusColor, // ✅ Status color
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Due: ${DateFormat('dd/MM/yyyy').format(milestone.dueDate!)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isOverdue ? Colors.red : Colors.grey[700],
                        ),
                      ),
                      if (isOverdue) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'OVERDUE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
