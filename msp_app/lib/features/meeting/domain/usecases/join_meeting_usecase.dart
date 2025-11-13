import '../repositories/meeting_stream_repository.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class JoinMeetingUsecase {
  final MeetingStreamRepository repo;
  JoinMeetingUsecase(this.repo);

  Future<Call> call(String callId) {
    return repo.joinCall(callId);
  }
}
