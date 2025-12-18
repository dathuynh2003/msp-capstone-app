import '../../../../core/network/api_config.dart';
import '../../../../core/network/http_client.dart';
import '../models/get_meeting_response.dart';
import 'package:msp_app/core/models/api_response.dart';
import 'dart:convert';

class MeetingRemoteDatasource {
  Future<List<GetMeetingResponse>> getMeetingsByUserId(String userId) async {
    final uri = Uri.parse("${ApiConfig.apiBaseUrl}/meetings/by-user/$userId");
    final response = await HttpClient.get(uri);

    final data = jsonDecode(response.body);
    final apiRes = ApiResponse<List<GetMeetingResponse>>.fromJson(
      data,
      (json) => List<GetMeetingResponse>.from(
        json.map((x) => GetMeetingResponse.fromJson(x)),
      ),
    );

    // print(data); // Xem toàn bộ structure JSON
    // print(data['data'].runtimeType); // Phải là List chứ không phải Map

    if (response.statusCode == 200 && apiRes.success) {
      if (apiRes.data == null) throw Exception("No meeting data returned!");
      return apiRes.data!;
    } else {
      throw Exception(apiRes.message);
    }
  }
}
