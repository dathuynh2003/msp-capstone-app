import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/project/data/models/project_detail_response.dart';

class ProjectDetailContent extends StatelessWidget {
  final ProjectDetailResponse project;
  final Future<void> Function()? onRefresh;
  const ProjectDetailContent({
    super.key,
    required this.project,
    this.onRefresh,
  });

  String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  String? formatDate(String? dt) {
    if (dt == null || dt.isEmpty) return "";
    try {
      final date = DateTime.parse(dt);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dt;
    }
  }

  // Helper: lấy màu status badge
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'inprogress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    List<Widget> assigneeAvatars = [];
    final showAvatars = project.members.take(3).toList();

    for (final m in showAvatars) {
      assigneeAvatars.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: (m.avatarUrl.isNotEmpty)
              ? CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(m.avatarUrl),
                  backgroundColor: Colors.grey[200],
                )
              : CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.deepPurple[100],
                  child: Text(
                    initials(m.fullName),
                    style: const TextStyle(
                      color: Color(0xFF232062),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
        ),
      );
    }

    if (project.members.length > 3) {
      assigneeAvatars.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: Text(
              '+${project.members.length - 3}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      color: const Color(0xFFFFA463),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[50]!, Colors.white, Colors.grey[50]!],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          children: [
            // PROJECT HEADER CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFA463), Color(0xFFCC7A2B)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA463).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.folder_special,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          project.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (project.description != null &&
                      project.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      project.description!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MEMBERS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(spacing: 4, children: assigneeAvatars),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'DUE DATE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  formatDate(project.endDate) ?? "N/A",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // TASKS HEADER
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA463),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA463).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${project.tasks.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFA463),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // TASKS LIST
            if (project.tasks.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.task_alt_outlined,
                        size: 60,
                        color: Colors.orangeAccent[400],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No tasks yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.orangeAccent[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This project has no tasks assigned.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
            else
              ...project.tasks.map((task) {
                DateTime? endDate;
                try {
                  endDate = task.endDate != null
                      ? DateTime.parse(task.endDate!)
                      : null;
                } catch (_) {}

                final status = task.status.trim().toLowerCase();
                final bool showFlag = status != "completed";
                Widget? flag;
                String? note;
                Color flagColor = Colors.grey;
                Color? labelColor;

                if (showFlag && endDate != null) {
                  if (now.isAfter(endDate)) {
                    flagColor = Colors.red;
                    note = "Overdue";
                    labelColor = Colors.red;
                    flag = Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.flag_rounded,
                        color: flagColor,
                        size: 16,
                      ),
                    );
                  } else {
                    final remaining = endDate.difference(now);
                    if (remaining.inDays >= 1) {
                      note = "${remaining.inDays}d left";
                    } else {
                      final hoursLeft = remaining.inHours < 1
                          ? 1
                          : (remaining.inHours + 1);
                      note = "${hoursLeft}h left";
                    }
                    flagColor = Colors.orange;
                    labelColor = Colors.orange[700];
                    flag = Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: flagColor,
                        size: 14,
                      ),
                    );
                  }
                }

                Widget? assigneeWidget;
                if (task.assignee != null) {
                  final assignee = task.assignee!;
                  assigneeWidget = Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 15,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                            children: [
                              TextSpan(
                                text: assignee.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: ' • ${assignee.email}',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Handle task tap
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      // Container(
                                      //   padding: const EdgeInsets.symmetric(
                                      //     horizontal: 10,
                                      //     vertical: 4,
                                      //   ),
                                      //   decoration: BoxDecoration(
                                      //     color: _getStatusColor(
                                      //       task.status,
                                      //     ).withOpacity(0.1),
                                      //     borderRadius: BorderRadius.circular(
                                      //       6,
                                      //     ),
                                      //   ),
                                      //   child: Text(
                                      //     task.status.toUpperCase(),
                                      //     style: TextStyle(
                                      //       fontSize: 10,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: _getStatusColor(task.status),
                                      //       letterSpacing: 0.5,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                if (flag != null) ...[
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      flag,
                                      if (note != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          note,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: labelColor,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            if (task.description != null &&
                                task.description!.trim().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                task.description!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (assigneeWidget != null) ...[
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 10),
                              assigneeWidget,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
