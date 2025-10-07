import 'package:flutter/material.dart';
import 'package:msp_app/shared/theme/app_colors.dart';
import '../../data/mock/schedule_mock_data.dart';
import '../../domain/entities/work_schedule.dart';
import '../widgets/month_header_widget.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/schedule_card_widget.dart';
import '../../../meeting/presentation/pages/meeting_detail.dart';

class MemberSchedulePage extends StatefulWidget {
  const MemberSchedulePage({super.key});

  @override
  State<MemberSchedulePage> createState() => _MemberSchedulePageState();
}

class _MemberSchedulePageState extends State<MemberSchedulePage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch Làm Việc',
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Month header
            MonthHeaderWidget(
              currentMonth: _currentMonth,
              onPreviousMonth: _previousMonth,
              onNextMonth: _nextMonth,
            ),
            
            // Calendar
            CalendarWidget(
              currentMonth: _currentMonth,
              selectedDate: _selectedDate,
              onDateSelected: _selectDate,
            ),
            
            // Schedule details
            Expanded(
              child: _buildScheduleDetails(),
            ),
          ],
        ),
      ),
    );
  }





  Widget _buildScheduleDetails() {
    final schedulesForDay = ScheduleMockData.getSchedulesForDate(_selectedDate);
    
    return Container(
      margin: const EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chi tiết ngày ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${schedulesForDay.length} sự kiện',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (schedulesForDay.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                itemCount: schedulesForDay.length,
                itemBuilder: (context, index) {
                  final schedule = schedulesForDay[index];
                  return ScheduleCardWidget(
                    schedule: schedule,
                    onTap: () {
                      if (schedule.type == 'meeting' && _shouldShowJoinButton(schedule)) {
                        _joinMeeting(schedule);
                      } else {
                        _showScheduleDetails(schedule);
                      }
                    },
                  );
                },
              ),
            ),
          ] else ...[
            _buildNoScheduleInfo(),
          ],
        ],
      ),
    );
  }


  Widget _buildNoScheduleInfo() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Không có lịch làm việc',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ngày nghỉ hoặc chưa có lịch',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }


  bool _shouldShowJoinButton(WorkSchedule schedule) {
    // Only for meetings
    if (schedule.type != 'meeting') return false;
    
    // Don't show if meeting is finished
    if (schedule.status == 'finished') return false;
    
    // Parse start time
    final startTimeParts = schedule.startTime.split(':');
    final startHour = int.parse(startTimeParts[0]);
    final startMinute = int.parse(startTimeParts[1]);
    
    // Create meeting start time for today
    final now = DateTime.now();
    final meetingStartTime = DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
      startHour,
      startMinute,
    );
    
    // Calculate 30 minutes before meeting
    final thirtyMinutesBefore = meetingStartTime.subtract(const Duration(minutes: 30));
    
    // Show button if current time is within 30 minutes before meeting start
    return now.isAfter(thirtyMinutesBefore) && now.isBefore(meetingStartTime);
  }

  void _joinMeeting(WorkSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tham gia cuộc họp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cuộc họp: Team Standup Meeting'),
            const SizedBox(height: 8),
            Text('Thời gian: ${schedule.timeRange}'),
            const SizedBox(height: 8),
            Text('Mô tả: Daily standup with development team to discuss progress and blockers'),
            if (schedule.notes != null) ...[
              const SizedBox(height: 8),
              Text('Ghi chú: ${schedule.notes}'),
            ],
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
              // TODO: Implement actual meeting join logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đang kết nối đến cuộc họp...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Tham gia'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetails(WorkSchedule schedule) {
    if (schedule.type == 'meeting') {
      // Navigate to meeting detail page - Hard coded to specific meeting ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetingDetailPage(
            meetingId: 'b558c91d-edc1-48d5-9bdd-738c977726bd',
          ),
        ),
      );
    } else {
      // Show task details dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Gateway Integration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thời gian: ${schedule.timeRange}'),
              const SizedBox(height: 8),
              const Text('Mô tả: Implement payment gateway for e-commerce platform with Stripe integration'),
              if (schedule.notes != null) ...[
                const SizedBox(height: 8),
                Text('Ghi chú: ${schedule.notes}'),
              ],
              if (schedule.tasks.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Nhiệm vụ:'),
                ...schedule.tasks.map((task) => Text('• $task')),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }
}
