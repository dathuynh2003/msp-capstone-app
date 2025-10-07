import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';
import '../widgets/project_overview_tab.dart';
import '../widgets/milestones_tab.dart';
import '../widgets/tasks_tab.dart';
import '../widgets/meetings_tab.dart';
import '../widgets/project_app_bar.dart';
import '../widgets/project_tab_bar.dart';
import '../widgets/project_fab.dart';

/// Main Project Detail Page với TabBar
class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectAppBar(project: widget.project),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectOverviewTab(project: widget.project),
          MilestonesTab(project: widget.project),
          TasksTab(project: widget.project),
          MeetingsTab(project: widget.project),
        ],
      ),
      bottomNavigationBar: ProjectTabBar(tabController: _tabController),
      floatingActionButton: ProjectFAB(project: widget.project),
    );
  }

}