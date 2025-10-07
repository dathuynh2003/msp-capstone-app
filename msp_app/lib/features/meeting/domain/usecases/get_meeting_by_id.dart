import 'package:stream_video_flutter/stream_video_flutter.dart';
import '../repositories/meeting_repository.dart';

/// Use case for getting meeting by ID
class GetMeetingById {
  final MeetingRepository _repository;
  
  GetMeetingById({required MeetingRepository repository})
      : _repository = repository;
  
  /// Execute the use case
  Future<QueriedCall?> call(String id) async {
    return await _repository.getMeetingById(id);
  }
}
