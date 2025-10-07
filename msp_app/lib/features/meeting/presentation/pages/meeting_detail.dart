import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:msp_app/shared/theme/app_colors.dart';
import '../../data/datasources/remote_datasource.dart';
import '../../domain/entities/meeting.dart';
import '../../domain/entities/project.dart';
import 'call_screen.dart';
import '../../../../core/providers/stream_video_provider.dart';

class MeetingDetailPage extends ConsumerStatefulWidget {
  final String meetingId;

  const MeetingDetailPage({
    super.key,
    required this.meetingId,
  });

  @override
  ConsumerState<MeetingDetailPage> createState() => _MeetingDetailPageState();
}

class _MeetingDetailPageState extends ConsumerState<MeetingDetailPage> {
  QueriedCall? _streamMeeting;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMeetingDetails();
  }

  Future<void> _loadMeetingDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get meeting from Stream API only
      final streamClient = ref.read(streamVideoClientProvider);
      if (streamClient == null) {
        setState(() {
          _isLoading = false;
          _error = 'Stream Video Client chưa được khởi tạo';
        });
        return;
      }
    
      
      final dataSource = MeetingRemoteDataSource(client: streamClient);
      
      // First try to get existing meeting
      var streamMeeting = await dataSource.getMeetingById(widget.meetingId);
      print('✅ Stream Meeting result: ${streamMeeting != null ? "Found" : "Not found"}');
      
      // If not found, try to create a test meeting
      // if (streamMeeting == null) {
      //   print('🔄 Meeting not found, trying to create test meeting...');
      //   final createdCall = await dataSource.createMeeting(
      //     title: 'Test Meeting',
      //     description: 'This is a test meeting created from Flutter',
      //     startTime: DateTime.now().add(const Duration(hours: 1)),
      //     participants: ['anonymous_user'],
      //     projectId: 'test_project',
      //     milestoneId: 'test_milestone',
      //     location: 'Online',
      //   );
        
      //   if (createdCall != null) {
      //     print('✅ Test meeting created successfully');
      //     // Try to get the meeting again
      //     streamMeeting = await dataSource.getMeetingById(widget.meetingId);
      //     print('✅ After creation, meeting result: ${streamMeeting != null ? "Found" : "Not found"}');
      //   } else {
      //     print('❌ Failed to create test meeting');
      //   }
      // }

      if (streamMeeting != null) {
        setState(() {
          _streamMeeting = streamMeeting;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Không tìm thấy cuộc họp trong Stream API';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Lỗi khi gọi Stream API: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết cuộc họp'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
              ),
              SizedBox(height: 16),
              Text(
                'Đang tải thông tin cuộc họp...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null || _streamMeeting == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết cuộc họp'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Không tìm thấy cuộc họp',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMeetingDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    // Use Stream meeting data only
    final meeting = _convertStreamMeetingToMeeting(_streamMeeting!);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết cuộc họp',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (meeting.status == 'scheduled' || meeting.status == 'ongoing')
            IconButton(
              icon: const Icon(Icons.video_call),
              onPressed: () => _joinMeeting(context, meeting),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meeting Header
              _buildMeetingHeader(meeting),
              const SizedBox(height: 16),
              
              // Meeting Details
              _buildMeetingDetails(meeting),
              const SizedBox(height: 16),
              
              // Project Information
              if (meeting.project != null) ...[
                _buildProjectInfo(meeting.project!),
                const SizedBox(height: 16),
              ],
              
              // Participants
              _buildParticipants(meeting),
              const SizedBox(height: 16),
              
              // Action Buttons
              _buildActionButtons(context, meeting),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingHeader(Meeting meeting) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: meeting.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.people,
                  color: meeting.statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: meeting.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        meeting.statusDisplayText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: meeting.statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            meeting.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingDetails(Meeting meeting) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.access_time,
            label: 'Thời gian bắt đầu',
            value: meeting.formattedStartTime,
          ),
          _buildDetailRow(
            icon: Icons.schedule,
            label: 'Thời gian kết thúc',
            value: meeting.status == 'finished' ? meeting.formattedEndTime : '--/--/---- --:--',
          ),
          _buildDetailRow(
            icon: Icons.timer,
            label: 'Thời lượng',
            value: meeting.durationFormatted,
          ),
          _buildDetailRow(
            icon: Icons.person,
            label: 'Người tạo',
            value: meeting.creatorName,
          ),
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Ngày tạo',
            value: meeting.formattedCreatedAt,
          ),
          if (meeting.notes != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.note,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ghi chú',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meeting.notes!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isLink ? AppColors.primary : Colors.grey[600],
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfo(Project project) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Thông tin dự án',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.folder,
            label: 'Tên dự án',
            value: project.name,
          ),
          _buildDetailRow(
            icon: Icons.description,
            label: 'Mô tả',
            value: project.description,
          ),
          _buildDetailRow(
            icon: Icons.trending_up,
            label: 'Trạng thái',
            value: project.statusDisplayText,
          ),
          _buildDetailRow(
            icon: Icons.person,
            label: 'Quản lý dự án',
            value: project.managerName,
          ),
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Ngày bắt đầu',
            value: project.formattedStartDate,
          ),
          if (project.formattedEndDate != null)
            _buildDetailRow(
              icon: Icons.event,
              label: 'Ngày kết thúc',
              value: project.formattedEndDate!,
            ),
          const SizedBox(height: 12),
          const Text(
            'Milestones liên quan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...project.milestones.map((milestone) => _buildMilestoneCard(milestone)),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Milestone milestone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getMilestoneStatusColor(milestone.status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  milestone.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.statusDisplayText,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getMilestoneStatusColor(milestone.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipants(Meeting meeting) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.people,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Thành viên tham gia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...meeting.participantNames.map((name) => _buildParticipantCard(name)),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              name.split(' ').last[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Meeting meeting) {
    return Column(
      children: [
        if (meeting.status == 'scheduled' || meeting.status == 'ongoing') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _joinMeeting(context, meeting),
              icon: const Icon(Icons.video_call),
              label: const Text('THAM GIA CUỘC HỌP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('QUAY LẠI'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getMilestoneStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'not_started':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _joinMeeting(BuildContext context, Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tham gia cuộc họp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cuộc họp: ${meeting.name}'),
            const SizedBox(height: 8),
            Text('Thời gian: ${meeting.formattedStartTime} - ${meeting.status == 'finished' ? meeting.formattedEndTime : '--/--/---- --:--'}'),
            const SizedBox(height: 16),
            const Text(
              'Bạn có muốn tham gia cuộc họp này không?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to CallScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallScreen(meeting: meeting),
                ),
              );
            },
            child: const Text('Tham gia'),
          ),
        ],
      ),
    );
  }

  /// Convert QueriedCall to Meeting entity
  Meeting _convertStreamMeetingToMeeting(QueriedCall queriedCall) {
    // For now, return a simple meeting with basic info
    // TODO: Extract more detailed info when Stream SDK API is stable
    return Meeting(
      id: 'stream_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Stream Meeting ${queriedCall.toString()}',
      description: 'Meeting from Stream API',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      status: 'scheduled',
      creatorId: 'system',
      creatorName: 'System',
      createdAt: DateTime.now(),
      participantNames: ['User 1', 'User 2'],
      notes: null,
      projectId: '',
      project: null,
    );
  }

}
