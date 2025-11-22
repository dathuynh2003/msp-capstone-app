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
}
