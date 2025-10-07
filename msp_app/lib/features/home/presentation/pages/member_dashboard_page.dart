import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'package:msp_app/shared/mock_data/project_mock_data.dart';
import 'package:msp_app/features/auth/presentation/pages/login_page.dart';
import 'package:msp_app/features/memberSchedule/presentation/pages/member_schedule_page.dart';
import 'package:msp_app/features/project/presentation/pages/project_detail_page.dart';
import 'package:msp_app/features/project/presentation/pages/list_projects_page.dart';
import 'package:msp_app/features/task/presentation/pages/list_tasks_page.dart';
import '../widgets/stats_cards_section.dart';
import '../widgets/upcoming_tasks_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/recent_activity_section.dart';

/// Member Dashboard Page với thiết kế hiện đại
/// Sử dụng màu cam chủ đạo
class MemberDashboardPage extends StatefulWidget {
  const MemberDashboardPage({super.key});

  @override
  State<MemberDashboardPage> createState() => _MemberDashboardPageState();
}

class _MemberDashboardPageState extends State<MemberDashboardPage> {
  // Color palette theo yêu cầu - sử dụng màu cam chủ đạo
  static const Color primaryOrange = Colors.orange;
  static final Color lightOrange = Colors.orange.shade300;
  static final Color veryLightOrange = Colors.orange.shade100;

  // User data từ SharedPreferences
  String userName = "User";
  String userEmail = "user@example.com";
  String userRole = "Member";
  String organizationName = "MSP Organization";

  // Lấy projects từ mock data
  List<Project> get projectsData => ProjectMockData.getProjects();

  // Task counts
  int get assignedTasksCount => 12;
  int get completedTasksCount => 8;
  int get pendingTasksCount => assignedTasksCount - completedTasksCount;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

          Future<void> _loadUserData() async {
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              userName = prefs.getString('userName') ?? "User";
              userEmail = prefs.getString('userEmail') ?? "user@example.com";
              userRole = prefs.getString('userRole') ?? "Member";
              organizationName = prefs.getString('organizationName') ?? "MSP Organization";
            });
          }

  // Mock upcoming tasks
  List<UpcomingTask> get upcomingTasks => [
    UpcomingTask(
      id: '1',
      title: 'Review UI Design',
      projectName: 'Website Redesign',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 'high',
      isOverdue: false,
    ),
    UpcomingTask(
      id: '2',
      title: 'Fix Login Bug',
      projectName: 'Mobile App Development',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: 'high',
      isOverdue: false,
    ),
    UpcomingTask(
      id: '3',
      title: 'Write Documentation',
      projectName: 'Website Redesign',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: 'medium',
      isOverdue: false,
    ),
    UpcomingTask(
      id: '4',
      title: 'Client Meeting Preparation',
      projectName: 'Marketing Campaign',
      dueDate: DateTime.now().add(const Duration(hours: 5)),
      priority: 'medium',
      isOverdue: false,
    ),
  ];

  // Mock recent activities
  List<RecentActivity> get recentActivities => [
    RecentActivity(
      id: '1',
      type: 'task_completed',
      description: 'Bạn đã hoàn thành task "Design Homepage"',
      projectName: 'Website Redesign',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    RecentActivity(
      id: '2',
      type: 'comment_added',
      description: 'Bạn đã comment trên "API Integration"',
      projectName: 'Mobile App Development',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    RecentActivity(
      id: '3',
      type: 'status_changed',
      description: 'Bạn đã thay đổi status của "User Testing" thành In Progress',
      projectName: 'Website Redesign',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RecentActivity(
      id: '4',
      type: 'task_completed',
      description: 'Bạn đã hoàn thành task "Setup Database"',
      projectName: 'Mobile App Development',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Stats Cards
                _buildStatsSection(),

                // Upcoming Tasks
                _buildUpcomingTasksSection(),

                // My Projects
                _buildProjectsSection(),

                // Recent Activity
                _buildRecentActivitySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate API call to refresh data
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Chào $userName 👋',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: primaryOrange,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            // Navigate to notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Navigate to search
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryOrange,
              lightOrange,
              veryLightOrange,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // User header với thiết kế gọn gàng hơn
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar với border đẹp
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // User name
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Organization name
                    Text(
                      organizationName,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Role badge gọn gàng
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        userRole,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Menu items với thiết kế hiện đại
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Main menu items
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          children: [
                            _buildDrawerItem(
                              icon: Icons.dashboard_rounded,
                              title: 'Bảng Điều Khiển',
                              subtitle: 'Tổng quan công việc',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.calendar_month_rounded,
                              title: 'Lịch Làm Việc',
                              subtitle: 'Quản lý lịch trình',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MemberSchedulePage(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.folder_rounded,
                              title: 'Dự Án Của Tôi',
                              subtitle: 'Xem tất cả dự án',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ListProjectsPage(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.assignment_rounded,
                              title: 'Nhiệm Vụ Của Tôi',
                              subtitle: 'Quản lý công việc',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ListTasksPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Logout button at bottom
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: _buildDrawerItem(
                          icon: Icons.logout_rounded,
                          title: 'Đăng Xuất',
                          subtitle: 'Thoát khỏi ứng dụng',
                          textColor: Colors.red[600],
                          iconColor: Colors.red[600],
                          onTap: () {
                            Navigator.pop(context);
                            _showLogoutDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Icon container với background đẹp
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? primaryOrange).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? primaryOrange,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                // Title và subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor ?? Colors.grey[800],
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Đăng Xuất',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                // Navigate back to login page
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng Xuất',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return StatsCardsSection(
      assignedTasksCount: assignedTasksCount,
      completedTasksCount: completedTasksCount,
      pendingTasksCount: pendingTasksCount,
    );
  }

          Widget _buildUpcomingTasksSection() {
            return UpcomingTasksSection(
              upcomingTasks: upcomingTasks,
            );
          }

          Widget _buildProjectsSection() {
            return ProjectsSection(
              projects: projectsData,
              onProjectTap: (project) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectDetailPage(project: project),
                  ),
                );
              },
            );
          }

  Widget _buildRecentActivitySection() {
    return RecentActivitySection(
      recentActivities: recentActivities,
    );
  }
}