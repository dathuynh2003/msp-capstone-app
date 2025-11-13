import 'package:stream_video_flutter/stream_video_flutter.dart';

class MeetingStreamDatasource {
  Future<Call> joinCall(String callId) async {
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.defaultType(),
      id: callId,
    );
    await call.getOrCreate();
    return call;
  }
}
