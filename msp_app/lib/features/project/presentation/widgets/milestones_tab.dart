import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'milestone_empty_state.dart';
import 'milestone_item_widget.dart';

/// Milestones Tab - Hiển thị danh sách milestones
class MilestonesTab extends StatelessWidget {
  final Project project;

  const MilestonesTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    if (project.milestones.isEmpty) {
      return MilestoneEmptyState(project: project);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: project.milestones.length,
      itemBuilder: (context, index) {
        return MilestoneItemWidget(
          project: project,
          index: index,
        );
      },
    );
  }

}
