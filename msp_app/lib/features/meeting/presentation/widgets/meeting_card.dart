import 'package:flutter/material.dart';
import '../../data/models/get_meeting_response.dart';
import 'glowing_button.dart';
import 'package:msp_app/features/meeting/presentation/pages/pre_join_meeting_page.dart';
import 'package:marquee/marquee.dart';

const Color orangeDeep = Color(0xFFFF5E13);
const Color orangeMid = Color(0xFFFFA463);
const Color orangeLight = Color(0xFFFFDBBD);

class MeetingCard extends StatelessWidget {
  final GetMeetingResponse meeting;
  final String userId;
  final String startTimeStr;
  final String endTimeStr;
  final String dateStr;
  final bool canJoin;
  const MeetingCard({
    super.key,
    required this.meeting,
    required this.userId,
    required this.startTimeStr,
    required this.endTimeStr,
    required this.dateStr,
    required this.canJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: orangeLight.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: orangeLight.withOpacity(0.09),
            blurRadius: 14,
            offset: const Offset(1, 9),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng đầu tiên dùng Stack để status luôn ở phải, icon luôn ở trái
            SizedBox(
              height: 40,
              child: Stack(
                children: [
                  // Icon cam ở góc trái
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: orangeMid.withOpacity(0.17),
                        shape: BoxShape.circle,
                        border: Border.all(color: orangeLight, width: 1),
                      ),
                      child: const Icon(
                        Icons.video_camera_front_rounded,
                        color: orangeDeep,
                        size: 22,
                      ),
                    ),
                  ),
                  // Status luôn góc phải, fix vị trí
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(meeting.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        meeting.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  // Title giữa, scroll ngang nếu quá dài, bị tràn sẽ nhỏ lại
                  Positioned.fill(
                    left: 50,
                    right: 85,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: meeting.title.length > 25
                          ? Marquee(
                              text: meeting.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                              velocity: 32.0,
                              blankSpace: 60.0,
                              startAfter: Duration(seconds: 2),
                              pauseAfterRound: Duration(milliseconds: 900),
                              fadingEdgeStartFraction: 0.1,
                              fadingEdgeEndFraction: 0.1,
                            )
                          : Text(
                              meeting.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Mô tả: ${meeting.description?.isNotEmpty ?? false ? meeting.description! : '(Không có mô tả)'}',
              style: const TextStyle(
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: orangeDeep, size: 15),
                const SizedBox(width: 5),
                Text(
                  dateStr,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.access_time_filled,
                  color: orangeMid,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  "$startTimeStr - $endTimeStr",
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                _iconLabel(
                  Icons.folder,
                  "Dự án: ${meeting.projectName}",
                  orangeDeep,
                ),
                if (meeting.milestoneName != null &&
                    meeting.milestoneName!.isNotEmpty)
                  _iconLabel(
                    Icons.flag,
                    "Milestone: ${meeting.milestoneName}",
                    orangeMid,
                  ),
                _iconLabel(
                  Icons.people,
                  "Tham gia: ${meeting.attendees.length}",
                  orangeDeep,
                ),
              ],
            ),
            if (canJoin)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GlowingButton(
                    text: "Tham gia",
                    icon: Icons.video_call,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreJoinMeetingPage(
                            meetingId: meeting.id,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconLabel(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.orange;
      case "ongoing":
        return Colors.blue;
      case "finished":
        return Colors.green;
      case "cancelled":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
