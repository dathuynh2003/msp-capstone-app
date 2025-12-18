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
  final String? highlightCommentId; // ✅ ADD: commentId to highlight

  const TaskDetailPage({
    super.key,
    required this.taskId,
    required this.projectId,
    this.highlightCommentId, // ✅ ADD: optional parameter
  });

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // ✅ ADD: Auto switch to Info tab if commentId exists
    if (widget.highlightCommentId != null) {
      debugPrint('');
      debugPrint('========================================');
      debugPrint('💡 [TaskDetailPage] HighlightCommentId detected');
      debugPrint('💡 CommentId: ${widget.highlightCommentId}');
      debugPrint('💡 Switching to Info tab (index 0)');
      debugPrint('========================================');

      // Ensure tab is set to Info (index 0)
      _tabController.index = 0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ Refresh handler
  Future<void> _handleRefresh() async {
    if (_isRefreshing) return; // Prevent multiple refreshes

    setState(() {
      _isRefreshing = true;
    });

    debugPrint('');
    debugPrint('========================================');
    debugPrint('🔄 [TaskDetailPage] Refreshing...');
    debugPrint('========================================');

    try {
      // Reset comments page to 1
      ref.read(commentsPageProvider(widget.taskId).notifier).state = 1;

      // Reload task detail
      await ref
          .read(taskDetailProvider(widget.taskId).notifier)
          .loadTaskDetail();

      debugPrint('✅ [TaskDetailPage] Refresh complete');
    } catch (e) {
      debugPrint('❌ [TaskDetailPage] Refresh error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('📋 [TaskDetailPage] Building...');
    debugPrint('📋 [TaskDetailPage] taskId: ${widget.taskId}');
    debugPrint('📋 [TaskDetailPage] projectId: ${widget.projectId}');
    debugPrint(
      '📋 [TaskDetailPage] highlightCommentId: ${widget.highlightCommentId}',
    ); // ✅ LOG
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
          // ✅ Add Refresh button
          actions: [
            IconButton(
              icon: _isRefreshing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.refresh, size: 26, color: Colors.white),
              onPressed: _isRefreshing ? null : _handleRefresh,
              splashRadius: 22,
              tooltip: "Refresh",
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: asyncTask.when(
        data: (task) {
          debugPrint('✅ [TaskDetailPage] Data loaded: ${task.title}');

          final statusColor = TaskStatusHelper.getTaskStatusColor(task.status);

          return Column(
            children: [
              // ✅ Fixed Header
              TaskDetailHeader(task: task),

              // ✅ Fixed TabBar
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: statusColor,
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
                              const Icon(Icons.flag_circle_outlined, size: 20),
                              if (task.milestones.isNotEmpty)
                                Positioned(
                                  right: -8,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
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
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
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

              // ✅ Scrollable TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ✅ UPDATED: Pass highlightCommentId to TaskInfoTab
                    TaskInfoTab(
                      task: task,
                      statusColor: statusColor,
                      highlightCommentId: widget.highlightCommentId, // ✅ PASS
                    ),
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
                  onPressed: _handleRefresh,
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
