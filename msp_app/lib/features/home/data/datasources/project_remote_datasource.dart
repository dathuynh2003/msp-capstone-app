import '../../../../../core/network/api_config.dart';
import '../../../../../core/network/http_client.dart';
import '../models/get_project_response.dart';
import 'package:msp_app/core/models/api_response.dart';
import 'package:msp_app/core/models/paging_response.dart';
import 'dart:convert';

class ProjectRemoteDatasource {
  Future<List<GetProjectResponse>> getProjectsByManagerId(
    String managerId,
  ) async {
    final uri = Uri.parse(
      "${ApiConfig.apiBaseUrl}/projects/by-manager/$managerId",
    );
    final response = await HttpClient.get(uri);
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
    final response = await HttpClient.get(uri);
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
