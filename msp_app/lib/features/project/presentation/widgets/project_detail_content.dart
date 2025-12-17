import 'package:flutter/material.dart';
import 'package:msp_app/features/project/data/models/project_detail_response.dart';
import 'package:msp_app/features/project/presentation/widgets/project_header_card.dart';
import 'package:msp_app/features/project/presentation/widgets/task_item_card.dart';
import 'package:msp_app/features/task/presentation/pages/task_detail_page.dart';

const Color pastelPeach = Color(0xFFFFD7BA);
const Color pastelPeachLight = Color(0xFFFFE9D9);
const Color pastelCream = Color(0xFFFFF5ED);
const Color orangeAccent = Color(0xFFFF9966);
const Color orangeTitle = Color(0xFFFF7716);

class ProjectDetailContent extends StatefulWidget {
  final ProjectDetailResponse project;
  final Future<void> Function()? onRefresh;
  final String? highlightTaskId;

  const ProjectDetailContent({
    super.key,
    required this.project,
    this.onRefresh,
    this.highlightTaskId,
  });

  @override
  State<ProjectDetailContent> createState() => _ProjectDetailContentState();
}

class _ProjectDetailContentState extends State<ProjectDetailContent>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _taskKeys = {};
  String? _currentHighlightId;
  bool _hasScrolled = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _scrollToAndHighlightTask(String taskId) async {
    if (!mounted) return;

    setState(() => _currentHighlightId = taskId);
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 1200));

    final key = _taskKeys[taskId];
    if (key != null && key.currentContext != null) {
      try {
        await Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.15,
        );
      } catch (_) {}
    }

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _pulseController.stop();
        _pulseController.reset();
        setState(() => _currentHighlightId = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final tasks = project.tasks;

    // Trigger scroll
    if (widget.highlightTaskId != null && !_hasScrolled && tasks.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hasScrolled = true;
        _scrollToAndHighlightTask(widget.highlightTaskId!);
      });
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh ?? () async {},
      color: orangeAccent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [pastelCream, Colors.white, pastelCream],
          ),
        ),
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          children: [
            // PROJECT HEADER
            ProjectHeaderCard(project: project),

            const SizedBox(height: 32),

            // TASKS HEADER
            _buildTasksHeader(tasks.length),

            const SizedBox(height: 16),

            // TASKS LIST
            if (tasks.isEmpty)
              _buildEmptyState()
            else
              ...tasks.map((task) {
                final taskId = task.taskId;
                _taskKeys[taskId] = GlobalKey();
                final isHighlighted = _currentHighlightId == taskId;

                return TaskItemCard(
                  task: task,
                  isHighlighted: isHighlighted,
                  pulseAnimation: _pulseAnimation,
                  itemKey: _taskKeys[taskId]!,
                  onTap: () {
                    debugPrint('👆 Tapped task: $taskId');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TaskDetailPage(
                          taskId: taskId,
                          projectId: project.projectId,
                        ),
                      ),
                    );
                  },
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksHeader(int taskCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 28,
            decoration: BoxDecoration(
              color: orangeAccent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Tasks',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: pastelPeachLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: pastelPeach, width: 1.5),
            ),
            child: Text(
              '$taskCount',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: orangeTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: pastelPeachLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: pastelPeachLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.task_alt_outlined,
              size: 64,
              color: orangeAccent,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This project has no tasks assigned.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
