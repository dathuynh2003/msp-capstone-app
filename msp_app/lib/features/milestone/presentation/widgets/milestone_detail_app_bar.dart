import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/milestone.dart';
import 'package:msp_app/core/permissions/permission_manager.dart';
import 'milestone_detail_dialogs.dart';

/// Custom AppBar widget for milestone detail page with action menu
class MilestoneDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Milestone milestone;

  const MilestoneDetailAppBar({
    Key? key,
    required this.milestone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(milestone.title),
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      actions: [
        FutureBuilder<bool>(
          future: PermissionManager.isProjectManager(),
          builder: (context, snapshot) {
            final canManage = snapshot.data == true;
            if (!canManage) {
              return const SizedBox.shrink();
            }
            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                switch (value) {
                  case 'update':
                    MilestoneDetailDialogs.showUpdateMilestoneDialog(context, milestone);
                    break;
                  case 'delete':
                    MilestoneDetailDialogs.showDeleteMilestoneDialog(context, milestone);
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'update',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue, size: 16),
                      SizedBox(width: 8),
                      Text('Cập nhật'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 16),
                      SizedBox(width: 8),
                      Text('Xóa'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
