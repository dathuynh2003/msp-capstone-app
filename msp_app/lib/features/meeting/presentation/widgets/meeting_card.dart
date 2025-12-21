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
    final statusColor = _getStatusColor(meeting.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor.withOpacity(0.1),
                    statusColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: statusColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.video_camera_front_rounded,
                      color: statusColor,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        meeting.title.length > 25
                            ? SizedBox(
                                height: 24,
                                child: Marquee(
                                  text: meeting.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ),
                                  velocity: 30.0,
                                  blankSpace: 50.0,
                                  startAfter: const Duration(seconds: 2),
                                  pauseAfterRound: const Duration(seconds: 1),
                                  fadingEdgeStartFraction: 0.1,
                                  fadingEdgeEndFraction: 0.1,
                                ),
                              )
                            : Text(
                                meeting.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                        const SizedBox(height: 4),
                        Text(
                          meeting.projectName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(meeting.status),
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          meeting.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (meeting.description?.isNotEmpty ?? false) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              meeting.description!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Date & Time
                  Row(
                    children: [
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.calendar_today,
                          label: dateStr,
                          color: orangeDeep,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.access_time_filled,
                          label: "$startTimeStr - $endTimeStr",
                          color: orangeMid,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Additional info
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (meeting.milestoneName != null &&
                          meeting.milestoneName!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.flag,
                          label: meeting.milestoneName!,
                          color: Colors.purple,
                        ),
                      _InfoChip(
                        icon: Icons.people,
                        label: "${meeting.attendees.length} Attendees",
                        color: Colors.blue,
                      ),
                    ],
                  ),

                  // Join button
                  if (canJoin) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: GlowingButton(
                        text: "Join Meeting",
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
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Icons.schedule;
      case "ongoing":
        return Icons.play_circle_filled;
      case "finished":
        return Icons.check_circle;
      case "cancelled":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}

// ✅ Info Chip Widget
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
