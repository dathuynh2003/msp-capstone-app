import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/task/data/datasources/task_remote_datasource.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';
import 'package:msp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:msp_app/features/task/domain/repositories/task_repository.dart';
import 'package:msp_app/features/task/domain/usecases/get_task_detail_usecase.dart';

// ✅ Constants
const int _commentsPageSize = 5;

// Datasource Provider
final taskRemoteDatasourceProvider = Provider<TaskRemoteDatasource>((ref) {
  return TaskRemoteDatasource();
});

// Repository Provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final datasource = ref.watch(taskRemoteDatasourceProvider);
  return TaskRepositoryImpl(datasource);
});

// Use Case Provider
final getTaskDetailUsecaseProvider = Provider<GetTaskDetailUsecase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetTaskDetailUsecase(repository);
});

// ✅ Task Detail State Notifier
class TaskDetailNotifier extends StateNotifier<AsyncValue<TaskDetailResponse>> {
  TaskDetailNotifier(this.usecase, this.taskId)
    : super(const AsyncValue.loading()) {
    loadTaskDetail();
  }

  final GetTaskDetailUsecase usecase;
  final String taskId;

  Future<void> loadTaskDetail() async {
    try {
      state = const AsyncValue.loading();
      final task = await usecase(taskId);
      state = AsyncValue.data(task);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void updateTask(TaskDetailResponse updatedTask) {
    state = AsyncValue.data(updatedTask);
  }
}

// ✅ Task Detail Provider
final taskDetailProvider =
    StateNotifierProvider.family<
      TaskDetailNotifier,
      AsyncValue<TaskDetailResponse>,
      String
    >((ref, taskId) {
      final usecase = ref.watch(getTaskDetailUsecaseProvider);
      return TaskDetailNotifier(usecase, taskId);
    });

// ✅ Comments Page State Provider
final commentsPageProvider = StateProvider.family<int, String>(
  (ref, taskId) => 1,
);

// ✅ Is Loading More Provider
final isLoadingMoreCommentsProvider = StateProvider.family<bool, String>(
  (ref, taskId) => false,
);

// ✅ Is Reloading Comments Provider
final isReloadingCommentsProvider = StateProvider.family<bool, String>(
  (ref, taskId) => false,
);

// ✅ Reload Comments Provider
final reloadCommentsProvider = Provider.family<Future<void> Function(), String>((
  ref,
  taskId,
) {
  return () async {
    final asyncTask = ref.read(taskDetailProvider(taskId));
    final currentTask = asyncTask.value;

    if (currentTask == null) {
      debugPrint('⚠️ Task is null, cannot reload');
      return;
    }

    if (ref.read(isReloadingCommentsProvider(taskId))) {
      debugPrint('⚠️ Already reloading comments');
      return;
    }

    try {
      debugPrint('');
      debugPrint('========================================');
      debugPrint('🔄 [Reload] Starting...');
      debugPrint(
        '🔄 Current: ${currentTask.comments.length}/${currentTask.totalComments}',
      );

      ref.read(isReloadingCommentsProvider(taskId).notifier).state = true;

      // Reset page to 1
      ref.read(commentsPageProvider(taskId).notifier).state = 1;

      debugPrint('🔄 Fetching fresh comments (page 1)...');

      final datasource = TaskRemoteDatasource();
      final freshComments = await datasource.getTaskComments(
        taskId,
        pageIndex: 1,
        pageSize: _commentsPageSize,
      );

      debugPrint('✅ Fetched ${freshComments.items.length} fresh comments');

      final updatedTask = currentTask.copyWith(
        comments: freshComments.items,
        totalComments: freshComments.totalItems,
      );

      debugPrint(
        '✅ Reloaded: ${updatedTask.comments.length}/${updatedTask.totalComments}',
      );
      debugPrint('========================================');

      ref.read(taskDetailProvider(taskId).notifier).updateTask(updatedTask);
    } catch (e, stackTrace) {
      debugPrint('❌ [Reload] Error: $e');
      debugPrint('❌ Stack: $stackTrace');
    } finally {
      ref.read(isReloadingCommentsProvider(taskId).notifier).state = false;
    }
  };
});

// ✅ Load More Comments Provider
final loadMoreCommentsProvider = Provider.family<Future<void> Function(), String>((
  ref,
  taskId,
) {
  return () async {
    final asyncTask = ref.read(taskDetailProvider(taskId));
    final currentTask = asyncTask.value;

    if (currentTask == null) {
      debugPrint('⚠️ Task is null, cannot load more');
      return;
    }

    if (ref.read(isLoadingMoreCommentsProvider(taskId))) {
      debugPrint('⚠️ Already loading more comments');
      return;
    }

    if (currentTask.comments.length >= currentTask.totalComments) {
      debugPrint('ℹ️ All comments already loaded');
      return;
    }

    try {
      debugPrint('');
      debugPrint('========================================');
      debugPrint('🔄 [LoadMore] Starting...');
      debugPrint(
        '🔄 Current: ${currentTask.comments.length}/${currentTask.totalComments}',
      );

      ref.read(isLoadingMoreCommentsProvider(taskId).notifier).state = true;

      final currentPage = ref.read(commentsPageProvider(taskId));
      final nextPage = currentPage + 1;

      debugPrint('🔄 Fetching page $nextPage...');

      final datasource = TaskRemoteDatasource();
      final newComments = await datasource.getTaskComments(
        taskId,
        pageIndex: nextPage,
        pageSize: _commentsPageSize,
      );

      debugPrint('✅ Fetched ${newComments.items.length} new comments');

      ref.read(commentsPageProvider(taskId).notifier).state = nextPage;

      final updatedTask = currentTask.copyWith(
        comments: [...currentTask.comments, ...newComments.items],
        totalComments: newComments.totalItems,
      );

      debugPrint(
        '✅ Updated: ${updatedTask.comments.length}/${updatedTask.totalComments}',
      );
      debugPrint('========================================');

      ref.read(taskDetailProvider(taskId).notifier).updateTask(updatedTask);
    } catch (e, stackTrace) {
      debugPrint('❌ [LoadMore] Error: $e');
      debugPrint('❌ Stack: $stackTrace');
    } finally {
      ref.read(isLoadingMoreCommentsProvider(taskId).notifier).state = false;
    }
  };
});
