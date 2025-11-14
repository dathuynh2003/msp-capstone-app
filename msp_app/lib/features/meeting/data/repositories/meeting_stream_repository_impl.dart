import '../../domain/repositories/meeting_stream_repository.dart';
import '../datasources/meeting_stream_datasource.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class MeetingStreamRepositoryImpl implements MeetingStreamRepository {
  final MeetingStreamDatasource datasource;
  MeetingStreamRepositoryImpl(this.datasource);

  @override
  Future<Call> joinCall(String callId) async {
    print('[MeetingStreamRepositoryImpl] joinCall: callId=$callId');
    try {
      final call = await datasource.joinCall(callId);
      print('[MeetingStreamRepositoryImpl] joinCall SUCCESS');
      return call;
    } catch (e, stack) {
      print('[MeetingStreamRepositoryImpl] ERROR: $e\n$stack');
      rethrow;
    }
  }
}
