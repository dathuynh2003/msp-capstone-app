import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/project/data/models/project_detail_response.dart';

// Widget hiện chi tiết project (nội dung nổi, các card task cũng nổi + border)
class ProjectDetailContent extends StatelessWidget {
  final ProjectDetailResponse project;
  final Future<void> Function()? onRefresh;
  const ProjectDetailContent({
    super.key,
    required this.project,
    this.onRefresh,
  });

  // Lấy initials từ tên
  String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  // Format ISO date -> dd/MM/yyyy
  String? formatDate(String? dt) {
    if (dt == null || dt.isEmpty) return "";
    try {
      final date = DateTime.parse(dt);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Hiển thị các member avatars max 3 + "+n"
    List<Widget> assigneeAvatars = [];
    final showAvatars = project.members.take(3).toList();
    for (final m in showAvatars) {
      assigneeAvatars.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: (m.avatarUrl.isNotEmpty)
              ? CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(m.avatarUrl),
                )
              : CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.deepPurple[100],
                  child: Text(
                    initials(m.fullName),
                    style: const TextStyle(
                      color: Color(0xFF232062),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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
            radius: 14,
            backgroundColor: Colors.grey[300],
            child: Text(
              '+${project.members.length - 3}',
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 18,
              spreadRadius: 8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            // Project title
            Text(
              project.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF232062),
              ),
            ),
            const SizedBox(height: 4),
            if (project.description != null &&
                project.description!.trim().isNotEmpty)
              Text(
                project.description!,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            const SizedBox(height: 18),

            // Assignees + Due date row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Members
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Members',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(children: assigneeAvatars),
                    ],
                  ),
                ),
                // Due date
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Due date      ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatDate(project.endDate) ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            const Divider(height: 2, thickness: 1.1),
            const SizedBox(height: 7),

            // TASKS LIST
            ...project.tasks.map((task) {
              // Xử lý flag, note
              DateTime? endDate;
              try {
                endDate = task.endDate != null
                    ? DateTime.parse(task.endDate!)
                    : null;
              } catch (_) {}
              final _status = (task.status).trim().toLowerCase();
              final bool showFlag = _status != "completed";
              Widget? flag;
              String? note;
              Color flagColor = Colors.grey;
              Color? labelColor;

              if (showFlag && endDate != null) {
                if (now.isAfter(endDate)) {
                  flagColor = Colors.redAccent;
                  note = "Overdue";
                  labelColor = Colors.redAccent;
                  flag = Container(
                    padding: const EdgeInsets.all(3.4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.redAccent.shade100,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.12),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(Icons.flag_rounded, color: flagColor, size: 18),
                  );
                } else {
                  final remaining = endDate.difference(now);
                  if (remaining.inDays >= 1) {
                    note = "${remaining.inDays} days left";
                  } else {
                    final hoursLeft = remaining.inHours < 1
                        ? 1
                        : (remaining.inHours + 1);
                    note = "$hoursLeft hours left";
                  }
                  flagColor = Colors.grey;
                  labelColor = Colors.grey[700];
                  flag = Container(
                    padding: const EdgeInsets.all(3.4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.10),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(Icons.flag_rounded, color: flagColor, size: 18),
                  );
                }
              }

              // Avatars nhóm người làm task này (một người)
              List<Widget> memberAvatars = [];
              if (task.assignee != null) {
                if (task.assignee!.avatarUrl.isNotEmpty) {
                  memberAvatars.add(
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(task.assignee!.avatarUrl),
                    ),
                  );
                } else {
                  memberAvatars.add(
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.deepOrange[100],
                      child: Text(
                        initials(task.assignee!.fullName),
                        style: const TextStyle(
                          color: Color(0xFF232062),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }
              }
              // Nếu muốn nhiều người thêm vào list này...

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.19),
                    width: 1.3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 14,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dòng trên: title, flag, note
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF232062),
                            ),
                          ),
                        ),
                        if (flag != null) flag,
                        if (flag != null) const SizedBox(width: 7),
                        if (note != null)
                          Text(
                            note,
                            style: TextStyle(
                              color: labelColor ?? Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    // subtitle/description nếu có
                    if (task.description != null &&
                        task.description!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    // Dòng dưới: avatar nhóm người làm (ở giữa)
                    if (memberAvatars.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(children: memberAvatars),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
