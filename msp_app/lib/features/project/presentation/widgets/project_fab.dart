import 'package:flutter/material.dart';
import 'package:msp_app/core/permissions/permission_manager.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'add_item_dialog.dart';

/// Custom FloatingActionButton widget for project detail page
class ProjectFAB extends StatelessWidget {
  final Project project;
  
  const ProjectFAB({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PermissionManager.isProjectManager(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return FloatingActionButton(
            onPressed: () {
              AddItemDialog.show(context, project: project);
            },
            backgroundColor: Colors.orange, // Màu cam chủ đạo
            mini: true, // Giảm size FAB
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
