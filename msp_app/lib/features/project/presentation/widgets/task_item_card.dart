import 'package:flutter/material.dart';
import 'package:msp_app/features/project/data/models/project_detail_response.dart';
import 'package:msp_app/features/project/presentation/utils/task_status_helper.dart';

const Color pastelPeach = Color(0xFFFFD7BA);
const Color pastelPeachLight = Color(0xFFFFE9D9);
const Color pastelCream = Color(0xFFFFF5ED);
const Color orangeAccent = Color(0xFFFF9966);

class TaskItemCard extends StatelessWidget {
  final ProjectTaskDto task;
  final bool isHighlighted;
  final Animation<double> pulseAnimation;
  final GlobalKey itemKey;
  final VoidCallback? onTap;

  const TaskItemCard({
    super.key,
    required this.task,
    required this.isHighlighted,
    required this.pulseAnimation,
    required this.itemKey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Status info
    final statusColor = TaskStatusHelper.getTaskStatusColor(task.status);
    final statusLabel = TaskStatusHelper.getStatusLabel(task.status);
    final statusIcon = TaskStatusHelper.getStatusIcon(task.status);

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isHighlighted ? pulseAnimation.value : 1.0,
          child: AnimatedContainer(
            key: itemKey,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(isHighlighted ? 6 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: isHighlighted
                  ? LinearGradient(
                      colors: [
                        pastelPeach.withOpacity(0.4),
                        pastelPeachLight.withOpacity(0.5),
                        pastelPeach.withOpacity(0.3),
                      ],
                    )
                  : null,
              border: isHighlighted
                  ? Border.all(color: orangeAccent, width: 3)
                  : null,
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: pastelPeach.withOpacity(0.6),
                        blurRadius: 24,
                        spreadRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                // ✅ Add status color border
                border: Border.all(
                  color: statusColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onTap,
                  child: Container(
                    // ✅ Add status color accent on left
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          statusColor.withOpacity(0.08),
                          statusColor.withOpacity(0.08),
                          statusColor.withOpacity(0.08),
                        ],
                        stops: const [0.0, 0.05, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ TITLE & STATUS ROW
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Status Color Indicator
                            Container(
                              width: 4,
                              height: 50,
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Title - Left
                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Status Badge - Right
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon,
                                    size: 13,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    statusLabel,
                                    style: TextStyle(
                                      fontSize: 11,
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

                        // ✅ DESCRIPTION
                        if (task.description != null &&
                            task.description!.trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              task.description!,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],

                        // ✅ ASSIGNEE
                        if (task.assignee != null) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 18,
                                      color: statusColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.assignee!.fullName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          task.assignee!.email,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
