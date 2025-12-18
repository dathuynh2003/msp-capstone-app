import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';
import 'package:msp_app/features/project/presentation/utils/task_status_helper.dart';

class TaskHistoryTab extends StatelessWidget {
  final List<TaskHistoryDto> histories;
  final Color statusColor;

  const TaskHistoryTab({
    super.key,
    required this.histories,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    if (histories.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(18),
        children: [_buildEmptyState()],
      );
    }

    final sortedHistories = [...histories]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      itemCount: sortedHistories.length,
      itemBuilder: (context, index) {
        final history = sortedHistories[index];
        final isFirst = index == 0;
        final isLast = sortedHistories.length - 1 == index;

        return _buildHistoryItem(
          history: history,
          isFirst: isFirst,
          isLast: isLast,
        );
      },
    );
  }

  Widget _buildHistoryItem({
    required TaskHistoryDto history,
    required bool isFirst,
    required bool isLast,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16, top: isFirst ? 18 : 0),
      child: IntrinsicHeight(
        // ✅ ADD THIS to fix Column height issue
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            Column(
              children: [
                // Top line
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 20,
                    color: statusColor.withOpacity(0.3),
                  ),

                // Circle
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),

                // Bottom line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: statusColor.withOpacity(0.3),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // ✅ ADD THIS
                  children: [
                    // ✅ Highlighted description
                    _buildHighlightedDescription(history),

                    const SizedBox(height: 8),

                    // User & Time
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            history.changedBy?.fullName ?? 'System',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(history.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Build highlighted description with colored status
  Widget _buildHighlightedDescription(TaskHistoryDto history) {
    final action = history.action;
    final oldValue = history.oldValue;
    final newValue = history.newValue;
    final fieldName = history.fieldName;
    final fromUser = history.fromUser;
    final toUser = history.toUser;

    // Helper: Status badge with color
    Widget statusBadge(String status, {bool isOld = false}) {
      final statusColorValue = TaskStatusHelper.getTaskStatusColor(status);
      final statusLabel = TaskStatusHelper.getStatusLabel(status);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isOld
              ? Colors.grey.shade100
              : statusColorValue.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isOld
                ? Colors.grey.shade400
                : statusColorValue.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Text(
          statusLabel,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isOld ? Colors.grey.shade700 : statusColorValue,
            letterSpacing: 0.3,
          ),
        ),
      );
    }

    // Helper: User badge
    Widget userBadge(String name, {bool isOld = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isOld ? Colors.red.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isOld ? Colors.red.shade300 : Colors.green.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person,
              size: 12,
              color: isOld ? Colors.red.shade700 : Colors.green.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isOld ? Colors.red.shade700 : Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    }

    // Helper: Date badge
    Widget dateBadge(String date, {bool isOld = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isOld ? Colors.red.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isOld ? Colors.red.shade300 : Colors.green.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 11,
              color: isOld ? Colors.red.shade700 : Colors.green.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isOld ? Colors.red.shade700 : Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    }

    // Helper: Text badge (for title/description)
    Widget textBadge(String text, {bool isOld = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isOld ? Colors.red.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isOld ? Colors.red.shade300 : Colors.green.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isOld ? Colors.red.shade700 : Colors.green.shade700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    switch (action) {
      case 'Created':
        return Row(
          children: [
            const Text(
              'Task ',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Created',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        );

      case 'Assigned':
        if (fromUser == null && toUser != null) {
          return Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Assigned task to',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              userBadge(toUser.fullName, isOld: false),
            ],
          );
        } else if (fromUser != null && toUser == null) {
          return Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Unassigned task from',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              userBadge(fromUser.fullName, isOld: true),
            ],
          );
        } else if (fromUser != null && toUser != null) {
          return Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Reassigned from',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              userBadge(fromUser.fullName, isOld: true),
              const Text(
                'to',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              userBadge(toUser.fullName, isOld: false),
            ],
          );
        }
        break;

      case 'Reassigned':
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Reassigned from',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            userBadge(fromUser?.fullName ?? 'N/A', isOld: true),
            const Text(
              'to',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            userBadge(toUser?.fullName ?? 'N/A', isOld: false),
          ],
        );

      case 'StatusChanged':
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Changed status from',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            statusBadge(oldValue ?? '', isOld: true),
            const Text(
              'to',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            statusBadge(newValue ?? '', isOld: false),
          ],
        );

      case 'Updated':
        if (fieldName == 'Title') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Changed title from',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              textBadge(oldValue ?? '', isOld: true),
              const SizedBox(height: 6),
              const Text(
                'to',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              textBadge(newValue ?? '', isOld: false),
            ],
          );
        } else if (fieldName == 'Description') {
          return const Text(
            'Updated description',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          );
        } else if (fieldName == 'StartDate') {
          return Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Changed start date from',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              dateBadge(oldValue ?? '', isOld: true),
              const Text(
                'to',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              dateBadge(newValue ?? '', isOld: false),
            ],
          );
        } else if (fieldName == 'EndDate') {
          return Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Changed deadline from',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              dateBadge(oldValue ?? '', isOld: true),
              const Text(
                'to',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              dateBadge(newValue ?? '', isOld: false),
            ],
          );
        } else {
          return Text(
            'Updated $fieldName',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          );
        }
    }

    return const Text(
      'Changed',
      style: TextStyle(fontSize: 13, color: Colors.black87),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No history yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Task changes will appear here',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
