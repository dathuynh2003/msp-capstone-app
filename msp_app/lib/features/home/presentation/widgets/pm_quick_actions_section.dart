import 'package:flutter/material.dart';

/// PM Quick Actions Section - Hiển thị các thao tác nhanh cho PM Dashboard
class PMQuickActionsSection extends StatelessWidget {
  final VoidCallback onCreateProject;
  final VoidCallback onCreateMeeting;
  final VoidCallback onViewProjects;
  final bool canCreateProject;
  final bool canCreateMeeting;

  const PMQuickActionsSection({
    super.key,
    required this.onCreateProject,
    required this.onCreateMeeting,
    required this.onViewProjects,
    this.canCreateProject = true,
    this.canCreateMeeting = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thao tác nhanh',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (canCreateProject) ...[
                Expanded(
                  child: _buildQuickActionItem(
                    'Tạo dự án',
                    Icons.add_chart,
                    Colors.blue,
                    onCreateProject,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (canCreateMeeting) ...[
                Expanded(
                  child: _buildQuickActionItem(
                    'Tạo cuộc họp',
                    Icons.video_call,
                    Colors.green,
                    onCreateMeeting,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: _buildQuickActionItem(
                  'Danh sách dự án',
                  Icons.list_alt,
                  Colors.orange,
                  onViewProjects,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
