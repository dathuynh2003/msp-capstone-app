import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Abstract repository interface for meeting operations
abstract class MeetingRepository {
  /// Get meeting by ID
  Future<QueriedCall?> getMeetingById(String id);
  
  /// Get all meetings for current user
  Future<List<QueriedCall>> getUserMeetings();
}
