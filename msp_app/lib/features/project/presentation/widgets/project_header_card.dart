import 'package:flutter/material.dart';
import 'package:msp_app/features/project/data/models/project_detail_response.dart';
import 'package:intl/intl.dart';

const Color pastelPeach = Color(0xFFFFD7BA);
const Color pastelPeachLight = Color(0xFFFFE9D9);
const Color orangeAccent = Color(0xFFFF9966);
const Color orangeTitle = Color(0xFFFF7716);

class ProjectHeaderCard extends StatelessWidget {
  final ProjectDetailResponse project;

  const ProjectHeaderCard({super.key, required this.project});

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

  @override
  Widget build(BuildContext context) {
    // Build assignee avatars
    List<Widget> assigneeAvatars = [];
    final showAvatars = project.members.take(3).toList();

    for (final m in showAvatars) {
      assigneeAvatars.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: (m.avatarUrl.isNotEmpty)
              ? CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(m.avatarUrl),
                  backgroundColor: Colors.grey[200],
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundColor: pastelPeachLight,
                  child: Text(
                    initials(m.fullName),
                    style: const TextStyle(
                      color: orangeTitle,
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
            radius: 18,
            backgroundColor: pastelPeachLight,
            child: Text(
              '+${project.members.length - 3}',
              style: const TextStyle(
                fontSize: 11,
                color: orangeTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [pastelPeach, Color.lerp(pastelPeach, Colors.white, 0.3)!],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: pastelPeach.withOpacity(0.2),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.folder_special_rounded,
                  color: orangeAccent,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  project.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: orangeTitle,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (project.description != null &&
              project.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                project.description!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TEAM MEMBERS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8D6E63),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(spacing: 6, children: assigneeAvatars),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'DEADLINE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8D6E63),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.event_rounded,
                          color: orangeAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatDate(project.endDate) ?? "N/A",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6D4C41),
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
    );
  }
}
