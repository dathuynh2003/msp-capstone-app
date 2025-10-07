import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';
import 'package:msp_app/shared/mock_data/project_mock_data.dart';
import 'project_detail_page.dart';
import 'package:msp_app/features/home/presentation/widgets/create_project_dialog.dart';
import 'package:msp_app/features/home/presentation/widgets/dashboard_models.dart' as models;
import 'package:msp_app/features/project/presentation/widgets/update_project_dialog.dart';
import 'package:msp_app/features/project/presentation/widgets/delete_project_dialog.dart';
import 'package:msp_app/features/project/presentation/widgets/task_dialogs.dart';
import 'package:msp_app/core/permissions/permission_manager.dart';
import 'package:msp_app/core/services/auth_service.dart';
import 'package:msp_app/features/auth/presentation/pages/login_page.dart';

/// List Projects Page - Hiển thị danh sách tất cả dự án
class ListProjectsPage extends StatefulWidget {
  const ListProjectsPage({super.key});

  @override
  State<ListProjectsPage> createState() => _ListProjectsPageState();
}

class _ListProjectsPageState extends State<ListProjectsPage> {
  // Color palette theo yêu cầu - sử dụng màu cam chủ đạo
  static const Color primaryOrange = Colors.orange;
  static final Color cream = Colors.orange.shade50;

  // Lấy projects từ mock data
  List<Project> get projectsData => ProjectMockData.getProjects();

  // Search và filter
  String _searchQuery = '';
  String _selectedStatus = 'Tất cả';
  final List<String> _statusOptions = ['Tất cả', 'Planning', 'In Progress', 'Active', 'Ongoing', 'Completed', 'On Hold', 'Delayed'];
  
  // Permission states
  bool _canCreateProject = false;
  bool _canUpdateProject = false;
  bool _canDeleteProject = false;

  // Mock team members for project creation
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

  // Filtered projects
  List<Project> get filteredProjects {
    List<Project> filtered = projectsData;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((project) =>
          project.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          project.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filter by status
    if (_selectedStatus != 'Tất cả') {
      filtered = filtered.where((project) => project.status == _selectedStatus).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final canCreate = await PermissionManager.canCreateProject();
    final canUpdate = await PermissionManager.canUpdateProject();
    final canDelete = await PermissionManager.canDeleteProject();
    final currentUserRole = await PermissionManager.getCurrentUserRole();
    
    setState(() {
      _canCreateProject = canCreate;
      _canUpdateProject = canUpdate;
      _canDeleteProject = canDelete;
    });
    
    // Debug print
    print('DEBUG - Current User Role: $currentUserRole');
    print('DEBUG - Can Create Project: $canCreate');
    print('DEBUG - Can Update Project: $canUpdate');
    print('DEBUG - Can Delete Project: $canDelete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search và Filter Section
          _buildSearchAndFilterSection(),
          
          // Projects List
          Expanded(
            child: _buildProjectsList(),
          ),
        ],
      ),
      floatingActionButton: _canCreateProject ? FloatingActionButton(
        onPressed: _showCreateOptionsDialog,
        backgroundColor: primaryOrange,
        mini: true, // Giảm size FAB
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ) : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Danh sách dự án',
        style: TextStyle(
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
          icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
          onPressed: _showFilterDialog,
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

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Tìm kiếm dự án...',
              hintStyle: const TextStyle(fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: primaryOrange, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    if (filteredProjects.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshProjects,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filteredProjects.length,
        itemBuilder: (context, index) {
          final project = filteredProjects[index];
          return _buildProjectCard(project);
        },
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailPage(project: project),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                cream,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.folder,
                      color: primaryOrange,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          project.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildActionMenu(project),
                ],
              ),
              const SizedBox(height: 12),

              // Project Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Milestones',
                      '${project.milestones.length}',
                      Icons.flag,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Tasks',
                      '${_getTotalTasksCount(project)}',
                      Icons.task,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Meetings',
                      '${project.meetings.length}',
                      Icons.people,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tiến độ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${project.progress}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: project.progress / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryOrange),
                    minHeight: 4,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Project Dates and Status
              Row(
                children: [
                  Expanded(
                    child: _buildDateItem(
                      'Bắt đầu',
                      '${project.startDate.day}/${project.startDate.month}/${project.startDate.year}',
                      Icons.play_arrow,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateItem(
                      'Kết thúc',
                      '${project.endDate.day}/${project.endDate.month}/${project.endDate.year}',
                      Icons.flag,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusChip(project.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'in progress':
        chipColor = Colors.orange;
        break;
      case 'planning':
        chipColor = Colors.blue;
        break;
      case 'on hold':
        chipColor = Colors.grey;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty || _selectedStatus != 'Tất cả'
                  ? 'Không tìm thấy dự án nào'
                  : 'Chưa có dự án nào',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty || _selectedStatus != 'Tất cả'
                  ? 'Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm'
                  : 'Các dự án sẽ hiển thị ở đây khi được tạo',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty || _selectedStatus != 'Tất cả') ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _selectedStatus = 'Tất cả';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Xóa bộ lọc', style: TextStyle(fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    String tempSelectedStatus = _selectedStatus;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Bộ lọc dự án',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Trạng thái dự án',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._statusOptions.map((status) {
                    return RadioListTile<String>(
                      title: Text(status, style: const TextStyle(fontSize: 12)),
                      value: status,
                      groupValue: tempSelectedStatus,
                      onChanged: (value) {
                        setDialogState(() {
                          tempSelectedStatus = value!;
                        });
                      },
                      activeColor: primaryOrange,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    );
                  }).toList(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempSelectedStatus = 'Tất cả';
                    });
                  },
                  child: Text(
                    'Xóa bộ lọc',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatus = tempSelectedStatus;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Áp dụng', style: TextStyle(fontSize: 12)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _refreshProjects() async {
    // Simulate API call to refresh projects
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  int _getTotalTasksCount(Project project) {
    return project.milestones.fold(0, (sum, milestone) => sum + milestone.tasks.length);
  }

  Widget _buildActionMenu(Project project) {
    // Nếu không có quyền update hoặc delete thì không hiển thị menu
    if (!_canUpdateProject && !_canDeleteProject) {
      return const SizedBox.shrink();
    }

    List<PopupMenuEntry<String>> menuItems = [];
    
    if (_canUpdateProject) {
      menuItems.add(
        const PopupMenuItem<String>(
          value: 'update',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Text('Cập nhật', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
    
    if (_canDeleteProject) {
      menuItems.add(
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Text('Xóa', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[600],
        size: 20,
      ),
      onSelected: (String value) {
        switch (value) {
          case 'update':
            _showUpdateProjectDialog(project);
            break;
          case 'delete':
            _showDeleteProjectDialog(project);
            break;
        }
      },
      itemBuilder: (BuildContext context) => menuItems,
    );
  }

  // Action methods
  void _showCreateOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder, color: Colors.orange),
              title: const Text('Tạo dự án'),
              onTap: () {
                Navigator.pop(context);
                _showCreateProjectDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.task, color: Colors.blue),
              title: const Text('Tạo nhiệm vụ'),
              onTap: () {
                Navigator.pop(context);
                _showCreateTaskDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

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
          // Refresh the projects list
          setState(() {});
        },
      ),
    );
  }

  void _showCreateTaskDialog() {
    // Show project selection dialog first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn dự án'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: projectsData.map((project) => ListTile(
                leading: const Icon(Icons.folder, color: Colors.orange),
                title: Text(project.name),
                subtitle: Text(project.description),
                onTap: () {
                  Navigator.pop(context);
                  TaskDialogs.showCreateTaskDialog(context, project);
                },
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateProjectDialog(Project project) {
    showDialog(
      context: context,
      builder: (context) => UpdateProjectDialog(
        project: project,
        onUpdateProject: (updateData) {
          // TODO: Implement actual project update logic
          print('Updating project: $updateData');
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dự án đã được cập nhật thành công!'),
              backgroundColor: Colors.blue,
            ),
          );
          // Refresh the projects list
          setState(() {});
        },
      ),
    );
  }

  void _showDeleteProjectDialog(Project project) {
    showDialog(
      context: context,
      builder: (context) => DeleteProjectDialog(
        project: project,
        onConfirmDelete: () {
          _deleteProject(project);
        },
      ),
    );
  }

  void _deleteProject(Project project) {
    // TODO: Implement actual project deletion logic
    print('Deleting project: ${project.id}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dự án "${project.name}" đã được xóa!'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Hoàn tác',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implement undo logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã hoàn tác việc xóa dự án'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
    // Refresh the projects list
    setState(() {});
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
