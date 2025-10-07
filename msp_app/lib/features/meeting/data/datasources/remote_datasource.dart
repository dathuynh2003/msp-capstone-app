import 'package:flutter/foundation.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Remote data source for meeting operations using Stream Video SDK
class MeetingRemoteDataSource {
  final StreamVideo _client;

  MeetingRemoteDataSource({required StreamVideo client}) : _client = client;

  /// Get meeting by ID using Stream API
  Future<QueriedCall?> getMeetingById(String callId) async {
    try {
      final result = await _client.queryCalls(
        filterConditions: {
          "id": callId, // hoặc call type phù hợp
          "type": "default",
        },
      );
      debugPrint(callId);

      final calls = result.getDataOrNull()?.calls ?? [];
      debugPrint('📋 Found ${calls.length} calls');
      return calls.isNotEmpty ? calls.first : null;
    } catch (e) {
      debugPrint('❌ Error getting call by ID: $e');
      return null;
    }
  }

  /// Get all meetings for current user
  Future<List<QueriedCall>> getUserMeetings() async {
    try {
      // Query all calls for current user
      final result = await _client.queryCalls(filterConditions: {});

      return result.getDataOrNull()?.calls ?? [];
    } catch (e) {
      throw Exception('Failed to get user meetings: $e');
    }
  }

  /// Create a new meeting
  // Future<Call?> createMeeting({
  //   required String title,
  //   required String description,
  //   required DateTime startTime,
  //   required List<String> participants,
  //   String? projectId,
  //   String? milestoneId,
  //   String? location,
  // }) async {
  //   try {
  //     debugPrint('🔄 Creating new meeting: $title');

  //     // Generate meeting ID
  //     final meetingId = 'b558c91d-edc1-48d5-9bdd-738c977726bd'; // Use the hardcoded ID

  //     // Create call
  //     final call = _client.call("default", meetingId);
  //     if (call == null) {
  //       debugPrint('❌ Failed to create call object');
  //       return null;
  //     }

  //     // Create or get the call with data
  //     await call.getOrCreate(
  //       data: {
  //         "custom": {
  //           "title": title,
  //           "description": description,
  //           "projectId": projectId,
  //           "milestoneId": milestoneId,
  //           "location": location,
  //           "participants": participants,
  //         },
  //         "starts_at": startTime.toIso8601String(),
  //         "members": participants.map((id) => {"user_id": id}).toList(),
  //       },
  //     );

  //     debugPrint('✅ Meeting created successfully: $meetingId');
  //     return call;
  //   } catch (e) {
  //     debugPrint('❌ Failed to create meeting: $e');
  //     debugPrint('❌ Error type: ${e.runtimeType}');
  //     return null;
  //   }
  // }
}
