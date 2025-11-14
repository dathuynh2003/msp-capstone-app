// features/meeting/domain/usecases/join_meeting_usecase.dart
import 'package:stream_video_flutter/stream_video_flutter.dart';
import '../repositories/meeting_stream_repository.dart';

class JoinMeetingUsecase {
  final MeetingStreamRepository repo;

  JoinMeetingUsecase(this.repo);

  Future<Call> call(
    String callId, {
    bool cameraOn = false,
    bool micOn = false,
  }) async {
    print(
      '[JoinMeetingUsecase] join meeting: callId=$callId, cam=$cameraOn, mic=$micOn',
    );
    try {
      final call = await repo.joinCall(callId);
      print('[JoinMeetingUsecase] joinCall SUCCESS');
      if (cameraOn) await call.setCameraEnabled(enabled: true);
      if (micOn) await call.setMicrophoneEnabled(enabled: true);
      return call;
    } catch (e, stack) {
      print('[JoinMeetingUsecase] ERROR: $e\n$stack');
      rethrow;
    }
  }
}
