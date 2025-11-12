import 'package:msp_app/features/meeting/data/models/get_meeting_response.dart';

abstract class MeetingRepository {
  Future<List<GetMeetingResponse>> getMeetingsByUserId(String userId);
}
