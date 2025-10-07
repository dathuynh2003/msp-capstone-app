import 'package:flutter/material.dart';
import 'package:msp_app/shared/theme/app_colors.dart';
import '../../data/mock/schedule_mock_data.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Calculate the number of weeks needed for this month
    final totalDays = lastDayOfMonth.day;
    final weeksNeeded = ((firstWeekday - 1) + totalDays + 6) ~/ 7;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weekday headers
          _buildWeekdayHeaders(),
          const SizedBox(height: 8),
          
          // Calendar grid with calculated height
          SizedBox(
            height: weeksNeeded * 50.0 + (weeksNeeded - 1) * 2.0,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: weeksNeeded * 7,
              itemBuilder: (context, index) {
                final dayNumber = index - firstWeekday + 2;
                final isCurrentMonth = dayNumber > 0 && dayNumber <= lastDayOfMonth.day;
                final date = isCurrentMonth 
                    ? DateTime(currentMonth.year, currentMonth.month, dayNumber)
                    : null;
                final isSelected = date != null && 
                    date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
                final isToday = date != null && 
                    date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day;
                final hasSchedule = date != null && 
                    ScheduleMockData.getSchedulesForDate(date).isNotEmpty;
                
                if (!isCurrentMonth) {
                  return Container();
                }
                
                return GestureDetector(
                  onTap: () => onDateSelected(date!),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primaryLight
                              : hasSchedule
                                  ? AppColors.primaryLighter
                                  : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: isToday 
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: isSelected 
                                ? Colors.white
                                : isToday
                                    ? Colors.white
                                    : hasSchedule
                                        ? AppColors.primary
                                        : Colors.grey[600],
                            fontWeight: isSelected || isToday 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        if (hasSchedule) ...[
                          const SizedBox(height: 2),
                          _buildDayDots(date),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Row(
      children: weekdays.map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildDayDots(DateTime date) {
    final schedulesForDay = ScheduleMockData.getSchedulesForDate(date);
    final taskCount = schedulesForDay.where((s) => s.type == 'task').length;
    final meetingCount = schedulesForDay.where((s) => s.type == 'meeting').length;
    final totalCount = taskCount + meetingCount;

    if (totalCount == 0) return const SizedBox.shrink();

    final List<Widget> dots = [];
    
    // Smart distribution: try to show both types if possible
    if (totalCount <= 3) {
      // Show all dots
      for (int i = 0; i < taskCount; i++) {
        dots.add(Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ));
      }
      for (int i = 0; i < meetingCount; i++) {
        dots.add(Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ));
      }
    } else {
      // Show max 3 dots with smart distribution
      if (taskCount > 0 && meetingCount > 0) {
        // Show at least 1 of each type
        dots.add(Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ));
        dots.add(Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ));
        // Add one more of the more common type
        if (taskCount >= meetingCount) {
          dots.add(Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ));
        } else {
          dots.add(Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ));
        }
      } else if (taskCount > 0) {
        // Only tasks
        for (int i = 0; i < 3; i++) {
          dots.add(Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ));
        }
      } else if (meetingCount > 0) {
        // Only meetings
        for (int i = 0; i < 3; i++) {
          dots.add(Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ));
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...dots,
        if (totalCount > 3) ...[
          const SizedBox(width: 2),
          Text(
            '+${totalCount - 3}',
            style: const TextStyle(
              fontSize: 8,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
