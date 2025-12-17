import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';

class TaskHistoryTab extends StatelessWidget {
  final List<TaskHistoryDto> histories;
  final Color statusColor; // ✅ Add statusColor

  const TaskHistoryTab({
    super.key,
    required this.histories,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    if (histories.isEmpty) {
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
                Icons.history,
                size: 64,
                color: statusColor, // ✅ Status color
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No activity history for this task yet.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final sortedHistories = [...histories]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      itemCount: sortedHistories.length,
      itemBuilder: (context, index) {
        final history = sortedHistories[index];
        final isLast = index == sortedHistories.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15), // ✅ Status color
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor.withOpacity(0.3), // ✅ Status color
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 14,
                    color: statusColor, // ✅ Status color
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: statusColor.withOpacity(0.3), // ✅ Status color
                  ),
              ],
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3), // ✅ Status color
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.1), // ✅ Status color
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.changeDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (history.changedBy != null) ...[
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(
                                0.2,
                              ), // ✅ Status color
                              shape: BoxShape.circle,
                              image: history.changedBy!.avatarUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        history.changedBy!.avatarUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: history.changedBy!.avatarUrl.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 14,
                                    color: statusColor,
                                  ) // ✅ Status color
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              history.changedBy!.fullName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(history.createdAt),
                          style: TextStyle(
                            fontSize: 11,
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
        );
      },
    );
  }
}
