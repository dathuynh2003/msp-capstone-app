import 'package:stream_video_flutter/stream_video_flutter.dart';

abstract class MeetingStreamRepository {
  Future<Call> joinCall(String callId);
}
