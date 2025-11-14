import 'package:stream_video_flutter/stream_video_flutter.dart';

class MeetingStreamDatasource {
  Future<Call> joinCall(String callId) async {
    print('[MeetingStreamDatasource] joinCall: callId=$callId');
    try {
      final call = StreamVideo.instance.makeCall(
        callType: StreamCallType.defaultType(),
        id: callId,
      );
      print('[MeetingStreamDatasource] Call created: ${call.id}');

      // Step 1: getOrCreate() để join hoặc tạo call nếu chưa tồn tại
      await call.getOrCreate();
      print('[MeetingStreamDatasource] getOrCreate SUCCESS');

      // Step 2: Join call để activate nó
      await call.join();
      print('[MeetingStreamDatasource] call.join() SUCCESS');

      // Lấy call state bằng .value
      final callState = call.state.value;
      print('[MeetingStreamDatasource] Call status: ${callState.status}');
      print(
        '[MeetingStreamDatasource] Call createdById: ${callState.createdByUserId}',
      );
      print(
        '[MeetingStreamDatasource] Participants count: ${callState.callParticipants.length}',
      );

      // In ra từng participant
      for (var participant in callState.callParticipants) {
        print(
          '[MeetingStreamDatasource] Participant: ${participant.userId} - ${participant.name}',
        );
      }

      print(
        '[MeetingStreamDatasource] Own userId: ${StreamVideo.instance.currentUser?.id}',
      );

      return call;
    } catch (e, stack) {
      print('[MeetingStreamDatasource] ERROR: $e\n$stack');
      rethrow;
    }
  }
}
