import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import '../../domain/usecases/join_meeting_usecase.dart';
import '../../data/datasources/meeting_stream_datasource.dart';
import '../../data/repositories/meeting_stream_repository_impl.dart';

// DataSource
final meetingStreamDatasourceProvider = Provider(
  (ref) => MeetingStreamDatasource(),
);
// Repository
final meetingStreamRepositoryProvider = Provider(
  (ref) =>
      MeetingStreamRepositoryImpl(ref.read(meetingStreamDatasourceProvider)),
);
// Usecase
final joinMeetingUsecaseProvider = Provider(
  (ref) => JoinMeetingUsecase(ref.read(meetingStreamRepositoryProvider)),
);

// FutureProvider UI: Nhận callId, gọi usecase join
final joinCallProvider = FutureProvider.family<Call, JoinCallParams>((
  ref,
  params,
) async {
  final joinMeeting = ref.read(joinMeetingUsecaseProvider);
  // Có thể truyền tham số bật/tắt camera/mic nếu cần luôn từ JoinCallParams
  return await joinMeeting(
    params.callId,
    cameraOn: params.cameraOn,
    micOn: params.micOn,
  );
});

class JoinCallParams {
  final String callId;
  final bool cameraOn;
  final bool micOn;

  JoinCallParams({
    required this.callId,
    required this.cameraOn,
    required this.micOn,
  });
}
