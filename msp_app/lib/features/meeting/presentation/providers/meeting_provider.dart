import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/meeting/data/models/get_meeting_response.dart';
import '../../data/datasources/meeting_remote_datasource.dart';
import '../../data/repositories/meeting_repository_impl.dart';
import '../../domain/usecases/get_meetings_by_user_id_usecase.dart';

// RemoteDatasource
final _meetingRemoteDatasourceProvider = Provider(
  (ref) => MeetingRemoteDatasource(),
);

// Repository
final meetingRepositoryProvider = Provider(
  (ref) => MeetingRepositoryImpl(ref.read(_meetingRemoteDatasourceProvider)),
);

// Usecase
final getMeetingsByUserIdUsecaseProvider = Provider(
  (ref) => GetMeetingsByUserIdUsecase(ref.read(meetingRepositoryProvider)),
);

// UI (fetch meeting list)
final meetingListProvider =
    FutureProvider.family<List<GetMeetingResponse>, String>((
      ref,
      userId,
    ) async {
      return ref.read(getMeetingsByUserIdUsecaseProvider).call(userId);
    });
// UI (filters)
final meetingStatusFilterProvider = StateProvider<String?>((ref) => null);
final meetingDateFilterProvider = StateProvider<DateTime?>((ref) => null);
// UI (show/hide filter section)
final showMeetingFilterProvider = StateProvider<bool>((ref) => false);
