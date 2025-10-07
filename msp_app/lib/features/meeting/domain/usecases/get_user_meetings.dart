import 'package:stream_video_flutter/stream_video_flutter.dart';
import '../repositories/meeting_repository.dart';

/// Use case for getting all user meetings
class GetUserMeetings {
  final MeetingRepository _repository;
  
  GetUserMeetings({required MeetingRepository repository})
      : _repository = repository;
  
  /// Execute the use case
  Future<List<QueriedCall>> call() async {
    return await _repository.getUserMeetings();
  }
}
