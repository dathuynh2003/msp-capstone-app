import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:msp_app/core/models/api_response.dart';
import 'package:msp_app/core/models/paging_response.dart';
import 'package:msp_app/core/network/api_config.dart';
import 'package:msp_app/core/network/http_client.dart';
import 'package:msp_app/features/task/data/models/task_comment_dto.dart';
import 'package:msp_app/features/task/data/models/task_detail_response.dart';

class TaskRemoteDatasource {
  // ✅ Get Task Detail (without history)
  Future<TaskDetailResponse> getTaskDetail(String taskId) async {
    final uri = Uri.parse('${ApiConfig.apiBaseUrl}/tasks/$taskId');

    debugPrint('📡 [TaskAPI] GET Task Detail: $uri');

    try {
      final response = await HttpClient.get(uri);

      debugPrint('🔍 [TaskAPI] Status: ${response.statusCode}');

      if (response.statusCode == 404) {
        throw Exception('Task not found');
      }

      if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      }

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final apiRes = ApiResponse<TaskDetailResponse>.fromJson(
        data,
        (json) => TaskDetailResponse.fromJson(json as Map<String, dynamic>),
      );

      if (!apiRes.success || apiRes.data == null) {
        throw Exception(apiRes.message);
      }

      debugPrint('✅ [TaskAPI] Task Detail Success: ${apiRes.data!.title}');
      return apiRes.data!;
    } catch (e) {
      debugPrint('❌ [TaskAPI] Task Detail Error: $e');
      rethrow;
    }
  }

  // ✅ Get Task History
  Future<List<TaskHistoryDto>> getTaskHistory(String taskId) async {
    // ✅ CORRECT ENDPOINT based on BE code
    final uri = Uri.parse(
      '${ApiConfig.apiBaseUrl}/TaskHistories/by-task/$taskId',
    );

    debugPrint('📡 [TaskAPI] GET Task History: $uri');

    try {
      final response = await HttpClient.get(uri);

      debugPrint('🔍 [TaskAPI] History Status: ${response.statusCode}');

      // ✅ Handle 404 - task not found, return empty
      if (response.statusCode == 404) {
        debugPrint('ℹ️ [TaskAPI] Task not found or no history');
        return [];
      }

      // ✅ Handle 400 - bad request, return empty
      if (response.statusCode == 400) {
        debugPrint('⚠️ [TaskAPI] Bad request: ${response.body}');
        return [];
      }

      // ✅ Other errors
      if (response.statusCode != 200) {
        debugPrint('⚠️ [TaskAPI] History error: ${response.statusCode}');
        return [];
      }

      // ✅ Check empty body
      if (response.body.isEmpty) {
        debugPrint('ℹ️ [TaskAPI] Empty history response');
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('🔍 [TaskAPI] History Response: $data');

      // ✅ Parse ApiResponse<IEnumerable<GetTaskHistoryResponse>>
      final apiRes = ApiResponse<List<TaskHistoryDto>>.fromJson(data, (json) {
        if (json == null) return [];

        if (json is List) {
          return json
              .map(
                (item) => TaskHistoryDto.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }

        return [];
      });

      if (apiRes.success && apiRes.data != null) {
        debugPrint(
          '✅ [TaskAPI] Task History Success: ${apiRes.data!.length} items',
        );
        return apiRes.data!;
      }

      debugPrint('ℹ️ [TaskAPI] No history data in response');
      return [];
    } catch (e) {
      debugPrint('⚠️ [TaskAPI] Task History Error: $e');
      return []; // Return empty list on error (don't break the app)
    }
  }

  // ✅ Get Task Comments (with pagination)
  Future<PagingResponse<TaskCommentDto>> getTaskComments(
    String taskId, {
    int pageIndex = 1,
    int pageSize = 5,
  }) async {
    // ✅ CORRECT: Use Uri.replace with queryParameters
    final baseUrl = Uri.parse('${ApiConfig.apiBaseUrl}/comments/task/$taskId');
    final uri = baseUrl.replace(
      queryParameters: {
        'PageIndex': pageIndex.toString(),
        'PageSize': pageSize.toString(),
      },
    );

    debugPrint('');
    debugPrint('========================================');
    debugPrint('📡 [TaskAPI] GET Task Comments');
    debugPrint('📡 Base URL: ${ApiConfig.apiBaseUrl}');
    debugPrint('📡 Full URL: $uri');
    debugPrint('📡 Query String: ${uri.query}'); // ✅ Check this
    debugPrint('📡 Query Params: ${uri.queryParameters}'); // ✅ Check this
    debugPrint('📡 TaskId: $taskId');
    debugPrint('📡 PageIndex: $pageIndex');
    debugPrint('📡 PageSize: $pageSize');
    debugPrint('========================================');

    try {
      final response = await HttpClient.get(uri);

      debugPrint('🔍 [TaskAPI] Comments Status: ${response.statusCode}');

      // ✅ Handle 404 - no comments found
      if (response.statusCode == 404) {
        debugPrint('ℹ️ [TaskAPI] No comments found for task');
        return PagingResponse(
          items: [],
          totalItems: 0,
          pageIndex: pageIndex,
          pageSize: pageSize,
        );
      }

      // ✅ Handle other errors
      if (response.statusCode != 200) {
        debugPrint('⚠️ [TaskAPI] Comments error: ${response.statusCode}');
        debugPrint(
          '⚠️ [TaskAPI] Response: ${response.body}',
        ); // ✅ Add response body
        return PagingResponse(
          items: [],
          totalItems: 0,
          pageIndex: pageIndex,
          pageSize: pageSize,
        );
      }

      if (response.body.isEmpty) {
        debugPrint('ℹ️ [TaskAPI] Empty comments response');
        return PagingResponse(
          items: [],
          totalItems: 0,
          pageIndex: pageIndex,
          pageSize: pageSize,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // ✅ Debug: Print data structure
      debugPrint('🔍 [TaskAPI] Response Keys: ${data.keys}');
      if (data['data'] != null) {
        final pagingData = data['data'] as Map<String, dynamic>;
        debugPrint('🔍 [TaskAPI] Paging Keys: ${pagingData.keys}');
        debugPrint('🔍 [TaskAPI] PageIndex: ${pagingData['pageIndex']}');
        debugPrint('🔍 [TaskAPI] PageSize: ${pagingData['pageSize']}');
        debugPrint('🔍 [TaskAPI] TotalItems: ${pagingData['totalItems']}');
        debugPrint(
          '🔍 [TaskAPI] Items Count: ${(pagingData['items'] as List).length}',
        );
      }

      // ✅ Parse ApiResponse<PagingResponse<GetCommentResponse>>
      final apiRes = ApiResponse<PagingResponse<TaskCommentDto>>.fromJson(
        data,
        (json) {
          if (json == null) {
            return PagingResponse(
              items: [],
              totalItems: 0,
              pageIndex: pageIndex,
              pageSize: pageSize,
            );
          }

          return PagingResponse.fromJson(
            json as Map<String, dynamic>,
            (item) => TaskCommentDto.fromJson(item as Map<String, dynamic>),
          );
        },
      );

      if (apiRes.success && apiRes.data != null) {
        debugPrint(
          '✅ [TaskAPI] Comments Success: ${apiRes.data!.items.length} items (${apiRes.data!.totalItems} total)',
        );
        debugPrint('✅ [TaskAPI] Returned PageIndex: ${apiRes.data!.pageIndex}');
        debugPrint('✅ [TaskAPI] Returned PageSize: ${apiRes.data!.pageSize}');
        return apiRes.data!;
      }

      debugPrint('ℹ️ [TaskAPI] No comments data in response');
      return PagingResponse(
        items: [],
        totalItems: 0,
        pageIndex: pageIndex,
        pageSize: pageSize,
      );
    } catch (e, stackTrace) {
      debugPrint('⚠️ [TaskAPI] Comments Error: $e');
      debugPrint('⚠️ [TaskAPI] Stack: $stackTrace');
      return PagingResponse(
        items: [],
        totalItems: 0,
        pageIndex: pageIndex,
        pageSize: pageSize,
      );
    }
  }

  // ✅ Get Task Detail With History (combines both APIs)
  Future<TaskDetailResponse> getTaskDetailWithHistory(String taskId) async {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('🔄 [TaskAPI] Fetching task with history...');
    debugPrint('🔄 [TaskAPI] Task ID: $taskId');
    debugPrint('========================================');

    try {
      // ✅ Call both APIs in parallel using Future.wait
      final results = await Future.wait([
        getTaskDetail(taskId),
        getTaskHistory(taskId),
        getTaskComments(taskId, pageSize: 5),
      ]);

      final taskDetail = results[0] as TaskDetailResponse;
      final taskHistories = results[1] as List<TaskHistoryDto>;
      final commentsResponse = results[2] as PagingResponse<TaskCommentDto>;

      debugPrint('');
      debugPrint('✅ [TaskAPI] Merge complete:');
      debugPrint('   📋 Task: ${taskDetail.title}');
      debugPrint('   📊 Status: ${taskDetail.status}');
      debugPrint('   📜 Histories: ${taskHistories.length} items');
      debugPrint('   📍 Milestones: ${taskDetail.milestones.length} items');
      debugPrint(
        '   💬 Comments: ${commentsResponse.items.length} items (${commentsResponse.totalItems} total)',
      );
      debugPrint('');

      // ✅ Create new TaskDetailResponse with merged history
      return TaskDetailResponse(
        id: taskDetail.id,
        projectId: taskDetail.projectId,
        userId: taskDetail.userId,
        reviewerId: taskDetail.reviewerId,
        title: taskDetail.title,
        description: taskDetail.description,
        status: taskDetail.status,
        startDate: taskDetail.startDate,
        endDate: taskDetail.endDate,
        isOverdue: taskDetail.isOverdue,
        createdAt: taskDetail.createdAt,
        updatedAt: taskDetail.updatedAt,
        user: taskDetail.user,
        reviewer: taskDetail.reviewer,
        milestones: taskDetail.milestones,
        taskHistories: taskHistories, // Merged histories
        comments: commentsResponse.items, // Merged comments
        totalComments: commentsResponse.totalItems,
      );
    } catch (e) {
      debugPrint('[TaskAPI] Error fetching task with history: $e');
      rethrow;
    }
  }
}
