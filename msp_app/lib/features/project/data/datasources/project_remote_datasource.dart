import 'package:msp_app/core/models/paging_response.dart';
import 'package:msp_app/features/home/data/models/get_project_response.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/network/http_client.dart';
import 'dart:convert';
import '../models/project_detail_response.dart';
import 'package:msp_app/core/models/api_response.dart';

class ProjectRemoteDatasource {
  Future<ProjectDetailResponse> getProjectDetailByUser({
    required String projectId,
    required String userId,
  }) async {
    final uri = Uri.parse(
      "${ApiConfig.apiBaseUrl}/projects/$projectId/by-user/$userId",
    );
    final response = await HttpClient.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );
    final data = jsonDecode(response.body);

    final apiRes = ApiResponse<ProjectDetailResponse>.fromJson(
      data,
      (json) => ProjectDetailResponse.fromJson(json),
    );

    if (response.statusCode == 200 && apiRes.success) {
      if (apiRes.data == null) throw Exception("No project detail returned!");
      return apiRes.data!;
    } else {
      throw Exception(apiRes.message);
    }
  }

  Future<List<GetProjectResponse>> getProjectsByManagerId(
    String managerId,
  ) async {
    final uri = Uri.parse(
      "${ApiConfig.apiBaseUrl}/projects/by-manager/$managerId",
    );
    final response = await HttpClient.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );
    final data = jsonDecode(response.body);

    // B1: Parse vào ApiResponse với PagingResponse<GetProjectResponse>
    final apiRes = ApiResponse<PagingResponse<GetProjectResponse>>.fromJson(
      data,
      (json) => PagingResponse<GetProjectResponse>.fromJson(
        json,
        (item) => GetProjectResponse.fromJson(item as Map<String, dynamic>),
      ),
    );

    if (response.statusCode == 200 && apiRes.success) {
      if (apiRes.data?.items == null)
        throw Exception("No project data returned!");
      return apiRes.data!.items;
    } else {
      throw Exception(apiRes.message);
    }
  }

  Future<List<GetProjectResponse>> getProjectsByMemberId(
    String memberId,
  ) async {
    final uri = Uri.parse(
      "${ApiConfig.apiBaseUrl}/projects/by-member/$memberId",
    );
    final response = await HttpClient.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );
    final data = jsonDecode(response.body);

    final apiRes = ApiResponse<PagingResponse<GetProjectResponse>>.fromJson(
      data,
      (json) => PagingResponse<GetProjectResponse>.fromJson(
        json,
        (item) => GetProjectResponse.fromJson(item as Map<String, dynamic>),
      ),
    );

    if (response.statusCode == 200 && apiRes.success) {
      if (apiRes.data?.items == null)
        throw Exception("No project data returned!");
      return apiRes.data!.items;
    } else {
      throw Exception(apiRes.message);
    }
  }
}
