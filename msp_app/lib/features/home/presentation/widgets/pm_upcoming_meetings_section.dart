import 'package:flutter/material.dart';

/// Meeting model for upcoming meetings
class Meeting {
  final String id;
  final String title;
  final String description;
  final String projectName;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final List<String> attendees;

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.attendees,
  });
}

/// PM Upcoming Meetings Section - Hiển thị các cuộc họp sắp tới cho PM Dashboard
class PMUpcomingMeetingsSection extends StatelessWidget {
  final VoidCallback onViewAllMeetings;
  final VoidCallback onViewMeetingDetails;

  const PMUpcomingMeetingsSection({
    super.key,
    required this.onViewAllMeetings,
    required this.onViewMeetingDetails,
  });

  // Mock upcoming meetings
  List<Meeting> get upcomingMeetings => [
    Meeting(
      id: '1',
      title: 'Họp review sprint',
      description: 'Review tiến độ sprint hiện tại và lập kế hoạch cho sprint tiếp theo',
      projectName: 'Website Redesign',
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      location: 'Phòng họp A',
      attendees: ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C'],
    ),
    Meeting(
      id: '2',
      title: 'Demo sản phẩm',
      description: 'Demo tính năng mới cho khách hàng',
      projectName: 'Mobile App Development',
      startTime: DateTime.now().add(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      location: 'Online - Zoom',
      attendees: ['Trần Thị B', 'Phạm Văn D', 'Nguyễn Thị E'],
    ),
    Meeting(
      id: '3',
      title: 'Họp kick-off dự án',
      description: 'Khởi động dự án mới và phân công nhiệm vụ',
      projectName: 'Marketing Campaign Q2',
      startTime: DateTime.now().add(const Duration(days: 2)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
      location: 'Phòng họp B',
      attendees: ['Lê Văn C', 'Phạm Văn D', 'Nguyễn Thị E', 'Trần Văn F'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cuộc họp sắp tới',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAllMeetings,
                child: const Text('Xem tất cả', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...upcomingMeetings.take(3).map((meeting) => _buildMeetingItem(meeting)),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(Meeting meeting) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Colors.orange.withValues(alpha: 0.08),
              Colors.orange.withValues(alpha: 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.orange.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(
              Icons.meeting_room,
              color: Colors.white,
              size: 18,
            ),
          ),
          title: Text(
            meeting.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 13,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                meeting.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 10, color: Colors.blue[700]),
                        const SizedBox(width: 2),
                        Text(
                          _formatMeetingTime(meeting.startTime),
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 10, color: Colors.green[700]),
                        const SizedBox(width: 2),
                        Text(
                          meeting.location,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      meeting.projectName,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, size: 8, color: Colors.purple[700]),
                        const SizedBox(width: 1),
                        Text(
                          '${meeting.attendees.length}',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.purple[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: onViewMeetingDetails,
        ),
      ),
    );
  }

  String _formatMeetingTime(DateTime startTime) {
    final now = DateTime.now();
    final difference = startTime.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày nữa';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ nữa';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút nữa';
    } else {
      return 'Đang diễn ra';
    }
  }
}
