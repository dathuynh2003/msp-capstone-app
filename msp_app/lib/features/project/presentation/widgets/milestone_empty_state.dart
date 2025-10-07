import 'package:flutter/material.dart';
import 'package:msp_app/core/permissions/permission_manager.dart';
import 'milestone_dialogs.dart';
import 'package:msp_app/shared/entities/project.dart';

/// Widget for displaying empty state when no milestones exist
class MilestoneEmptyState extends StatelessWidget {
  final Project project;

  const MilestoneEmptyState({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.flag, size: 48, color: Colors.orange.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có cột mốc nào',
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo cột mốc đầu tiên để bắt đầu dự án',
            style: TextStyle(fontSize: 12, color: Colors.orange.shade500),
          ),
          const SizedBox(height: 12),
          FutureBuilder<bool>(
            future: PermissionManager.isProjectManager(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return ElevatedButton.icon(
                  onPressed: () => MilestoneDialogs.showCreateMilestoneDialog(context, project),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Thêm cột mốc',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
