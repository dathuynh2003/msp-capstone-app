import 'package:stream_video_flutter/stream_video_flutter.dart';

class MeetingStreamDatasource {
  Future<Call> joinCall(String callId) async {
    print('[MeetingStreamDatasource] joinCall: callId=$callId');
    try {
      final user = StreamVideo.instance.currentUser;
      print('[MeetingStreamDatasource] Current user: ${user.id}');

      final call = StreamVideo.instance.makeCall(
        callType: StreamCallType.defaultType(),
        id: callId,
      );

      await call.getOrCreate();
      print('[MeetingStreamDatasource] getOrCreate SUCCESS');

      await call.join();
      print('[MeetingStreamDatasource] call.join() SUCCESS');

      // Đợi cho đến khi có participants hoặc timeout
      int attempt = 0;
      while (attempt < 10) {
        final callState = call.state.value;
        print(
          '[MeetingStreamDatasource] Attempt ${attempt + 1}: Status=${callState.status}, Participants=${callState.callParticipants.length}',
        );

        if (callState.callParticipants.isNotEmpty) {
          print('[MeetingStreamDatasource] Found participants!');
          break;
        }

        attempt++;
        if (attempt < 10) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      final callState = call.state.value;
      print('[MeetingStreamDatasource] Final Status: ${callState.status}');
      print(
        '[MeetingStreamDatasource] Final Participants: ${callState.callParticipants.length}',
      );

      for (var p in callState.callParticipants) {
        print('[MeetingStreamDatasource] - ${p.userId}: ${p.name}');
      }

      return call;
    } catch (e, stack) {
      print('[MeetingStreamDatasource] ERROR: $e\n$stack');
      rethrow;
    }
  }
}
