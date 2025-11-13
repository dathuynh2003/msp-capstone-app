import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import '../../domain/usecases/join_meeting_usecase.dart';
import '../../data/datasources/meeting_stream_datasource.dart';
import '../../data/repositories/meeting_stream_repository_impl.dart';

final meetingStreamDatasourceProvider = Provider(
  (ref) => MeetingStreamDatasource(),
);
final meetingStreamRepositoryProvider = Provider(
  (ref) =>
      MeetingStreamRepositoryImpl(ref.read(meetingStreamDatasourceProvider)),
);
final joinMeetingUsecaseProvider = Provider(
  (ref) => JoinMeetingUsecase(ref.read(meetingStreamRepositoryProvider)),
);

final joinCallProvider = FutureProvider.family<Call, String>((
  ref,
  callId,
) async {
  final joinMeeting = ref.read(joinMeetingUsecaseProvider);
  return await joinMeeting(callId);
});
