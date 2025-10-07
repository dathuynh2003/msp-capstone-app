import 'package:flutter/material.dart';
import '../../domain/entities/work_schedule.dart';

class ScheduleCardWidget extends StatelessWidget {
  final WorkSchedule schedule;
  final VoidCallback onTap;

  const ScheduleCardWidget({
    super.key,
    required this.schedule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(schedule.type).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with type and priority
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(schedule.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(schedule.type),
                  color: _getStatusColor(schedule.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusText(schedule.type).toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(schedule.type),
                      ),
                    ),
                    Text(
                      _getScheduleTitle(schedule),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (schedule.type == 'task') ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(schedule),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getPriorityText(schedule),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            _getScheduleDescription(schedule),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Time and status
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                schedule.timeRange,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(schedule.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getStatusColor(schedule.type),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusDisplayText(schedule.type, schedule.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(schedule.type),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getStatusColor(schedule.type),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getActionButtonText(schedule),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _getActionButtonIcon(schedule.type),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String type) {
    switch (type) {
      case 'task':
        return Colors.orange;
      case 'meeting':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String type) {
    switch (type) {
      case 'task':
        return 'Công việc';
      case 'meeting':
        return 'Cuộc họp';
      default:
        return 'Không xác định';
    }
  }

  IconData _getStatusIcon(String type) {
    switch (type) {
      case 'task':
        return Icons.work;
      case 'meeting':
        return Icons.people;
      default:
        return Icons.event;
    }
  }

  String _getScheduleTitle(WorkSchedule schedule) {
    switch (schedule.type) {
      case 'task':
        return 'Payment Gateway Integration';
      case 'meeting':
        return 'Team Standup Meeting';
      default:
        return 'Sự kiện';
    }
  }

  String _getScheduleDescription(WorkSchedule schedule) {
    switch (schedule.type) {
      case 'task':
        return 'Implement payment gateway for e-commerce platform with Stripe integration';
      case 'meeting':
        return 'Daily standup with development team to discuss progress and blockers';
      default:
        return schedule.notes ?? 'No description available';
    }
  }

  Color _getPriorityColor(WorkSchedule schedule) {
    // Mock priority based on time
    if (schedule.startTime == '09:00') {
      return Colors.red; // High priority
    } else if (schedule.startTime == '14:00') {
      return Colors.orange; // Medium priority
    }
    return Colors.green; // Low priority
  }

  String _getPriorityText(WorkSchedule schedule) {
    if (schedule.startTime == '09:00') {
      return 'CAO';
    } else if (schedule.startTime == '14:00') {
      return 'TRUNG BÌNH';
    }
    return 'THẤP';
  }

  String _getStatusDisplayText(String type, String status) {
    if (type == 'task') {
      switch (status) {
        case 'todo':
          return 'Chưa bắt đầu';
        case 'ongoing':
          return 'Đang thực hiện';
        case 'review':
          return 'Đang review';
        case 'completed':
          return 'Hoàn thành';
        default:
          return 'Không xác định';
      }
    } else if (type == 'meeting') {
      switch (status) {
        case 'scheduled':
          return 'Đã lên lịch';
        case 'ongoing':
          return 'Đang diễn ra';
        case 'finished':
          return 'Đã kết thúc';
        default:
          return 'Không xác định';
      }
    }
    return 'Không xác định';
  }

  String _getActionButtonText(WorkSchedule schedule) {
    switch (schedule.type) {
      case 'task':
        return 'XEM CHI TIẾT';
      case 'meeting':
        if (_shouldShowJoinButton(schedule)) {
          return 'THAM GIA';
        } else {
          return 'XEM CHI TIẾT';
        }
      default:
        return 'XEM CHI TIẾT';
    }
  }

  IconData _getActionButtonIcon(String type) {
    switch (type) {
      case 'task':
        return Icons.arrow_forward;
      case 'meeting':
        return Icons.phone;
      default:
        return Icons.arrow_forward;
    }
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
}
