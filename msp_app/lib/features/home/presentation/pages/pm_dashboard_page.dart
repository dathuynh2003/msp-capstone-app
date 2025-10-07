import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'package:msp_app/shared/mock_data/project_mock_data.dart';
import 'package:msp_app/features/project/presentation/pages/project_detail_page.dart';
import 'package:msp_app/features/home/presentation/widgets/pm_overview_stats_section.dart';
import 'package:msp_app/features/home/presentation/widgets/pm_quick_actions_section.dart';
import 'package:msp_app/features/home/presentation/widgets/pm_upcoming_meetings_section.dart';
import 'package:msp_app/features/home/presentation/widgets/pm_projects_header_section.dart';
import 'package:msp_app/features/home/presentation/widgets/create_project_dialog.dart';
import 'package:msp_app/features/home/presentation/widgets/dashboard_models.dart' as models;
import 'package:msp_app/core/permissions/permission_manager.dart';
import 'package:msp_app/core/services/auth_service.dart';
import 'package:msp_app/features/auth/presentation/pages/login_page.dart';

/// PM Dashboard Page - Trang chủ cho Project Manager
class PMDashboardPage extends StatefulWidget {
  const PMDashboardPage({super.key});

  @override
  State<PMDashboardPage> createState() => _PMDashboardPageState();
}

class _PMDashboardPageState extends State<PMDashboardPage> {
  // Color palette theo yêu cầu - sử dụng màu cam chủ đạo
  static const Color primaryOrange = Colors.orange;

  // User data từ SharedPreferences
  String userName = "Project Manager";
  String userEmail = "pm@example.com";
  String userRole = "Project Manager";
  String organizationName = "MSP Organization";
  
  // Permission states
  bool _canCreateProject = false;
  bool _canCreateMeeting = false;

  // Lấy projects từ mock data
  List<Project> get projectsData => ProjectMockData.getProjects();

  // Project stats
  int get totalProjects => projectsData.length;
  int get activeProjects => projectsData.where((p) => p.status == 'In Progress' || p.status == 'Active').length;
  int get completedProjects => projectsData.where((p) => p.status == 'Completed').length;
  int get totalTasks => projectsData.fold(0, (sum, project) => sum + _getTotalTasksCount(project));
  int get completedTasks => projectsData.fold(0, (sum, project) => sum + _getCompletedTasksCount(project));
  int get totalTeamMembers => 24; // Mock data

  // Mock team members
  List<models.TeamMember> get teamMembers => [
    models.TeamMember(
      id: '1',
      name: 'Nguyễn Văn A',
      role: 'Senior Developer',
      avatarUrl: '',
      assignedTasks: 12,
      performance: 95.5,
    ),
    models.TeamMember(
      id: '2',
      name: 'Trần Thị B',
      role: 'UI/UX Designer',
      avatarUrl: '',
      assignedTasks: 8,
      performance: 88.2,
    ),
    models.TeamMember(
      id: '3',
      name: 'Lê Văn C',
      role: 'Backend Developer',
      avatarUrl: '',
      assignedTasks: 15,
      performance: 92.7,
    ),
    models.TeamMember(
      id: '4',
      name: 'Phạm Thị D',
      role: 'QA Engineer',
      avatarUrl: '',
      assignedTasks: 10,
      performance: 96.1,
    ),
    models.TeamMember(
      id: '5',
      name: 'Hoàng Văn E',
      role: 'DevOps',
      avatarUrl: '',
      assignedTasks: 6,
      performance: 89.8,
    ),
  ];

  // Mock upcoming meetings
  List<models.Meeting> get upcomingMeetings => [
    models.Meeting(
      id: '1',
      title: 'Họp review sprint',
      description: 'Review tiến độ sprint hiện tại và lập kế hoạch cho sprint tiếp theo',
      projectName: 'Website Redesign',
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      location: 'Phòng họp A',
      attendees: ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C'],
    ),
    models.Meeting(
      id: '2',
      title: 'Demo sản phẩm',
      description: 'Demo tính năng mới cho khách hàng',
      projectName: 'Mobile App Development',
      startTime: DateTime.now().add(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      location: 'Online - Zoom',
      attendees: ['Trần Thị B', 'Phạm Văn D', 'Nguyễn Thị E'],
    ),
    models.Meeting(
      id: '3',
      title: 'Họp kick-off dự án',
      description: 'Khởi động dự án mới và phân công nhiệm vụ',
      projectName: 'Marketing Campaign Q2',
      startTime: DateTime.now().add(const Duration(days: 2)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
      location: 'Phòng họp B',
      attendees: ['Lê Văn C', 'Phạm Văn D', 'Nguyễn Thị E', 'Trần Văn F'],
    ),
  ];

  final int _selectedFilter = 0; // 0: All, 1: Active, 2: Delayed, 3: Planning

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final canCreateProject = await PermissionManager.canCreateProject();
    final canCreateMeeting = await PermissionManager.canCreateMeeting();
    final currentUserRole = await PermissionManager.getCurrentUserRole();
    
    setState(() {
      userName = prefs.getString('userName') ?? "Project Manager";
      userEmail = prefs.getString('userEmail') ?? "pm@example.com";
      userRole = prefs.getString('userRole') ?? "Project Manager";
      organizationName = prefs.getString('organizationName') ?? "MSP Organization";
      _canCreateProject = canCreateProject;
      _canCreateMeeting = canCreateMeeting;
    });
    
    // Debug print
    print('DEBUG - Current User Role: $currentUserRole');
    print('DEBUG - Can Create Project: $canCreateProject');
    print('DEBUG - Can Create Meeting: $canCreateMeeting');
    print('DEBUG - Stored User Role: ${prefs.getString('userRole')}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Overview Stats
            SliverToBoxAdapter(
              child: PMOverviewStatsSection(
                totalProjects: totalProjects,
                activeProjects: activeProjects,
                totalTasks: totalTasks,
                completedTasks: completedTasks,
                totalTeamMembers: totalTeamMembers,
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: PMQuickActionsSection(
                onCreateProject: _showCreateProjectDialog,
                onCreateMeeting: _showCreateMeetingDialog,
                onViewProjects: _viewProjectsList,
                canCreateProject: _canCreateProject,
                canCreateMeeting: _canCreateMeeting,
              ),
            ),

            // Cuộc họp sắp tới
            SliverToBoxAdapter(
              child: PMUpcomingMeetingsSection(
                onViewAllMeetings: () {
                  // Navigate to all meetings
                },
                onViewMeetingDetails: () {
                  // Navigate to meeting details
                },
              ),
            ),

            // Projects Header với filter
            SliverToBoxAdapter(
              child: PMProjectsHeaderSection(
                onViewAllProjects: _viewProjectsList,
              ),
            ),

            // Projects List
            _buildProjectsList(),
          ],
        ),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Xin chào, $userName 👋',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: primaryOrange,
      elevation: 0,
      toolbarHeight: 56, // Giảm chiều cao AppBar
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none, color: Colors.white, size: 20),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
              ),
            ],
          ),
          onPressed: _showNotifications,
          iconSize: 20,
        ),
        IconButton(
          icon: const Icon(Icons.analytics, color: Colors.white, size: 20),
          onPressed: _showAnalytics,
          iconSize: 20,
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white, size: 20),
          onPressed: _logout,
          iconSize: 20,
        ),
      ],
    );
  }








  Widget _buildProjectsList() {
    final filteredProjects = _getFilteredProjects();
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = filteredProjects[index];
          return _buildProjectItem(project);
        },
        childCount: filteredProjects.length,
      ),
    );
  }

  Widget _buildProjectItem(Project project) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailPage(project: project),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(project.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      project.status,
                      style: TextStyle(
                        color: _getStatusColor(project.status),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              
              // Project Description
              Text(
                project.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              
              // Progress and Stats
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${project.progress}% hoàn thành',
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        '${_getCompletedTasksCount(project)}/${_getTotalTasksCount(project)} tasks',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: project.progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(project.progress)),
                    minHeight: 4,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Team and Timeline Info
              Row(
                children: [
                  // Team
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          '${project.milestones.length} milestones',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'PM: ${project.projectManager}',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Timeline
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timeline',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          'Bắt đầu: ${_formatDate(project.startDate)}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Hạn: ${_formatDate(project.endDate)}',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Helper methods
  List<Project> _getFilteredProjects() {
    switch (_selectedFilter) {
      case 1: // Active
        return projectsData.where((p) => p.status == 'Active' || p.status == 'In Progress').toList();
      case 2: // Delayed
        return projectsData.where((p) => p.status == 'Delayed').toList();
      case 3: // Planning
        return projectsData.where((p) => p.status == 'Planning').toList();
      default: // All
        return projectsData;
    }
  }

  int _getTotalTasksCount(Project project) {
    return project.milestones.fold(0, (sum, milestone) => sum + milestone.tasks.length);
  }

  int _getCompletedTasksCount(Project project) {
    return project.milestones.fold(0, (sum, milestone) {
      return sum + milestone.tasks.where((task) => task.status.toLowerCase() == 'completed').length;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'active':
        return Colors.blue;
      case 'delayed':
        return Colors.red;
      case 'planning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(int progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 50) return Colors.blue;
    if (progress >= 30) return Colors.orange;
    return Colors.red;
  }






  // Helper methods
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Action methods
  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateProjectDialog(
        teamMembers: teamMembers,
        onCreateProject: (projectData) {
          // TODO: Implement actual project creation logic
          print('Creating project: $projectData');
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dự án đã được tạo thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showCreateMeetingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo cuộc họp mới'),
        content: const Text('Tính năng tạo cuộc họp mới sẽ được triển khai ở đây...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _viewProjectsList() {
    Navigator.pushNamed(context, '/projects');
  }

  void _showNotifications() {
    // Navigate to notifications page
  }

  void _showAnalytics() {
    // Navigate to analytics page
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close confirmation dialog first
              Navigator.pop(dialogContext);
              
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (loadingContext) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              
              try {
                // Logout with timeout
                await Future.any([
                  AuthService.logout(),
                  Future.delayed(const Duration(seconds: 2)), // 2 second timeout
                ]);
                
                // Hide loading dialog
                if (mounted) {
                  Navigator.pop(context);
                }
                
                // Navigate to login
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                }
              } catch (e) {
                // Hide loading dialog if there's an error
                if (mounted) {
                  Navigator.pop(context);
                }
                
                // Show error message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi đăng xuất: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }


}
