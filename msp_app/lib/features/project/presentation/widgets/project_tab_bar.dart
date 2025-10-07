import 'package:flutter/material.dart';

/// Custom TabBar widget for project detail page
class ProjectTabBar extends StatelessWidget {
  final TabController tabController;

  const ProjectTabBar({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: TabBar(
        controller: tabController,
        isScrollable: false,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
        tabs: const [
          Tab(
            icon: Icon(Icons.dashboard, size: 18),
            text: 'Tổng quan',
          ),
          Tab(
            icon: Icon(Icons.flag, size: 18),
            text: 'Cột mốc',
          ),
          Tab(
            icon: Icon(Icons.task, size: 18),
            text: 'Nhiệm vụ',
          ),
          Tab(
            icon: Icon(Icons.meeting_room, size: 18),
            text: 'Cuộc họp',
          ),
        ],
      ),
    );
  }
}
