import 'package:msp_app/features/meeting/data/models/get_meeting_response.dart';

import '../repositories/meeting_repository.dart';

class GetMeetingsByUserIdUsecase {
  final MeetingRepository repo;

  GetMeetingsByUserIdUsecase(this.repo);

  Future<List<GetMeetingResponse>> call(String userId) {
    return repo.getMeetingsByUserId(userId);
  }
}
