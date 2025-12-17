import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/project/domain/params/project_detail_params.dart';
import 'package:msp_app/features/project/presentation/providers/project_detail_provider.dart';
import 'package:msp_app/features/project/presentation/widgets/project_detail_content.dart';
import 'package:msp_app/features/home/presentation/providers/user_provider.dart';

const Color orangeDeep = Color(0xFFFFA463);
const Color orangeGold = Color(0xFFFDF0D2);

class ProjectDetailPage extends ConsumerWidget {
  final String projectId;
  final String? highlightTaskId;

  const ProjectDetailPage({
    super.key,
    required this.projectId,
    this.highlightTaskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('🏗️ [ProjectDetailPage] Building...');
    debugPrint('🏗️ [ProjectDetailPage] projectId: $projectId');
    debugPrint('🏗️ [ProjectDetailPage] highlightTaskId: $highlightTaskId');
    debugPrint('========================================');

    final user = ref.watch(userProvider);
    final userId = user.userId;
    final params = ProjectDetailParams(projectId, userId);

    final asyncDetail = ref.watch(projectDetailProvider(params));

    Future<void> refresh() async {
      ref.invalidate(projectDetailProvider(params));
      await Future.delayed(const Duration(milliseconds: 350));
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
            'Project Detail',
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
            tooltip: "Trở về",
          ),
        ),
      ),
      body: asyncDetail.when(
        data: (detail) {
          debugPrint('✅ [ProjectDetailPage] Data loaded successfully');
          debugPrint('✅ [ProjectDetailPage] Project name: ${detail.name}');
          debugPrint(
            '✅ [ProjectDetailPage] Tasks count: ${detail.tasks.length}',
          );
          if (detail.tasks.isNotEmpty) {
            debugPrint(
              '✅ [ProjectDetailPage] First task: ${detail.tasks.first.taskId}',
            );
          }
          return ProjectDetailContent(
            project: detail,
            onRefresh: refresh,
            highlightTaskId: highlightTaskId,
          );
        },
        loading: () {
          debugPrint('⏳ [ProjectDetailPage] Loading data...');
          return const Center(
            child: CircularProgressIndicator(color: orangeDeep),
          );
        },
        error: (err, stack) {
          debugPrint('❌ [ProjectDetailPage] Error: $err');
          debugPrint('❌ [ProjectDetailPage] Stack: $stack');
          return Center(
            child: Text(
              'Lỗi tải dự án: $err',
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
