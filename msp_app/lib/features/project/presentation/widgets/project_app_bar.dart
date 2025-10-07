import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';

/// Custom AppBar widget for project detail page
class ProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Project project;

  const ProjectAppBar({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        project.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.orange, // Màu cam chủ đạo
      foregroundColor: Colors.white,
      toolbarHeight: 56, // Giảm chiều cao AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
