import '../../domain/repositories/meeting_repository.dart';
import '../datasources/meeting_remote_datasource.dart';
import '../models/get_meeting_response.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingRemoteDatasource remote;

  MeetingRepositoryImpl(this.remote);

  @override
  Future<List<GetMeetingResponse>> getMeetingsByUserId(String userId) async {
    final meetings = await remote.getMeetingsByUserId(userId);
    return meetings;
  }
}
