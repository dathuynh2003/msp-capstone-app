import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/task/presentation/providers/task_detail_provider.dart';
import 'package:msp_app/features/task/presentation/widgets/task_detail_header.dart';
import 'package:msp_app/features/task/presentation/widgets/task_info_tab.dart';
import 'package:msp_app/features/task/presentation/widgets/task_milestone_tab.dart';
import 'package:msp_app/features/task/presentation/widgets/task_history_tab.dart';
import 'package:msp_app/features/project/presentation/utils/task_status_helper.dart';

const Color orangeDeep = Color(0xFFFFA463);
const Color pastelCream = Color(0xFFFFF5ED);

class TaskDetailPage extends ConsumerStatefulWidget {
  final String taskId;
  final String projectId;

  const TaskDetailPage({
    super.key,
    required this.taskId,
    required this.projectId,
  });

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('📋 [TaskDetailPage] Building...');
    debugPrint('📋 [TaskDetailPage] taskId: ${widget.taskId}');
    debugPrint('📋 [TaskDetailPage] projectId: ${widget.projectId}');
    debugPrint('========================================');

    final asyncTask = ref.watch(taskDetailProvider(widget.taskId));

    return Scaffold(
      backgroundColor: pastelCream,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: orangeDeep,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          title: const Text(
            'Task Detail',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left_outlined,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 22,
            tooltip: "Back",
          ),
        ),
      ),
      body: asyncTask.when(
        data: (task) {
          debugPrint('✅ [TaskDetailPage] Data loaded: ${task.title}');

          // ✅ Get status color for theming
          final statusColor = TaskStatusHelper.getTaskStatusColor(task.status);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(taskDetailProvider(widget.taskId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            color: statusColor, // ✅ Use status color
            child: Column(
              children: [
                // Header
                TaskDetailHeader(task: task),

                // ✅ TabBar with status color
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3), // ✅ Status color
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.1), // ✅ Status color
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: statusColor, // ✅ Use status color
                      borderRadius: BorderRadius.circular(14),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(4),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: [
                      const Tab(
                        icon: Icon(Icons.info_outline, size: 20),
                        text: 'Info',
                      ),
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.flag_circle_outlined,
                                  size: 20,
                                ),
                                if (task.milestones.isNotEmpty)
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red, // ✅ Use status color
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '${task.milestones.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text('Milestones'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(Icons.history, size: 20),
                                if (task.taskHistories.isNotEmpty)
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red, // ✅ Use status color
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '${task.taskHistories.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text('History'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ TabBarView - Pass statusColor
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TaskInfoTab(task: task, statusColor: statusColor),
                      TaskMilestoneTab(
                        milestones: task.milestones,
                        statusColor: statusColor,
                      ),
                      TaskHistoryTab(
                        histories: task.taskHistories,
                        statusColor: statusColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () {
          debugPrint('⏳ [TaskDetailPage] Loading...');
          return const Center(
            child: CircularProgressIndicator(color: orangeDeep),
          );
        },
        error: (error, stack) {
          debugPrint('❌ [TaskDetailPage] Error: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(taskDetailProvider(widget.taskId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeDeep,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
