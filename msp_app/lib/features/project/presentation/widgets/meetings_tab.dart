import 'package:flutter/material.dart';
import 'package:msp_app/shared/entities/project.dart';

/// Meetings Tab - Hiển thị danh sách meetings
class MeetingsTab extends StatelessWidget {
  final Project project;

  const MeetingsTab({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (project.meetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.meeting_room,
                size: 48,
                color: Colors.green.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có cuộc họp nào',
              style: TextStyle(
                fontSize: 16, 
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lên lịch cuộc họp đầu tiên để thảo luận dự án',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: project.meetings.length,
      itemBuilder: (context, index) {
        final meeting = project.meetings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.green.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xem chi tiết cuộc họp: ${meeting.title}')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.meeting_room,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            meeting.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                        _buildMeetingStatusChip(meeting),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(
                      meeting.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Info Row
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _buildInfoChip(
                          Icons.schedule,
                          '${meeting.startTime.day}/${meeting.startTime.month}/${meeting.startTime.year} ${meeting.startTime.hour}:${meeting.startTime.minute.toString().padLeft(2, '0')}',
                          Colors.blue,
                        ),
                        _buildInfoChip(
                          Icons.location_on,
                          'Địa điểm: ${meeting.location}',
                          Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Footer Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${meeting.participantNames.length} người tham gia',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeetingStatusChip(dynamic meeting) {
    // Giả sử meeting có status hoặc dựa vào thời gian để xác định status
    String status = _getMeetingStatus(meeting);
    Color chipColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getMeetingStatus(dynamic meeting) {
    final now = DateTime.now();
    final meetingTime = meeting.startTime;
    
    if (meetingTime.isBefore(now)) {
      return 'Đã kết thúc';
    } else if (meetingTime.isBefore(now.add(const Duration(hours: 1)))) {
      return 'Sắp diễn ra';
    } else {
      return 'Sắp tới';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã kết thúc':
        return Colors.grey;
      case 'Sắp diễn ra':
        return Colors.orange;
      case 'Sắp tới':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
