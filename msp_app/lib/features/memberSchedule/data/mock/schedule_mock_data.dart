import '../../domain/entities/work_schedule.dart';

class ScheduleMockData {
  static List<WorkSchedule> getWorkSchedules() {
    final now = DateTime.now();
    final schedules = <WorkSchedule>[];

    // Generate schedules for the current month
    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i - 15)); // -15 to +15 days from now
      
      // Skip weekends (Saturday = 6, Sunday = 7)
      if (date.weekday == 6 || date.weekday == 7) {
        continue;
      }

      // Add multiple events for each day
      
      // 1. Morning task
      schedules.add(WorkSchedule(
        id: 'schedule_${date.millisecondsSinceEpoch}_1',
        userId: 'user_1',
        date: date,
        startTime: '09:00',
        endTime: '12:00',
        type: 'task',
        status: 'ongoing',
        notes: 'High priority task for Q4 release',
        tasks: ['Setup Stripe API', 'Test payment flow', 'Document integration'],
        isWorkDay: true,
      ));

      // 2. Team standup meeting
      schedules.add(WorkSchedule(
        id: 'meeting_1',
        userId: 'user_1',
        date: date,
        startTime: '09:30',
        endTime: '10:00',
        type: 'meeting',
        status: 'scheduled',
        notes: 'Daily standup with development team',
        tasks: ['Report progress', 'Discuss blockers', 'Plan next tasks'],
        isWorkDay: true,
      ));

      // 3. Afternoon task
      schedules.add(WorkSchedule(
        id: 'schedule_${date.millisecondsSinceEpoch}_3',
        userId: 'user_1',
        date: date,
        startTime: '14:00',
        endTime: '17:00',
        type: 'task',
        status: 'todo',
        notes: 'Focus on security and performance',
        tasks: ['Design API endpoints', 'Implement authentication', 'Write unit tests'],
        isWorkDay: true,
      ));

      // 4. Client meeting (every other day)
      if (i % 2 == 0) {
        schedules.add(WorkSchedule(
          id: 'meeting_2',
          userId: 'user_1',
          date: date,
          startTime: '15:00',
          endTime: '16:00',
          type: 'meeting',
          status: 'scheduled',
          notes: 'Review project progress with client',
          tasks: ['Prepare demo', 'Present progress', 'Collect feedback'],
          isWorkDay: true,
        ));
      }

      // 5. Additional task (some days)
      if (i % 3 == 0) {
        schedules.add(WorkSchedule(
          id: 'schedule_${date.millisecondsSinceEpoch}_5',
          userId: 'user_1',
          date: date,
          startTime: '10:30',
          endTime: '11:30',
          type: 'task',
          status: 'review',
          notes: 'Code review and testing',
          tasks: ['Review pull requests', 'Run test suite', 'Fix bugs'],
          isWorkDay: true,
        ));
      }

      // 6. Code review meeting (some days)
      if (i % 4 == 0) {
        schedules.add(WorkSchedule(
          id: 'meeting_4',
          userId: 'user_1',
          date: date,
          startTime: '16:30',
          endTime: '17:30',
          type: 'meeting',
          status: 'finished',
          notes: 'Review code changes and discuss improvements',
          tasks: ['Review PR #123', 'Review PR #124', 'Discuss improvements'],
          isWorkDay: true,
        ));
      }
    }

    return schedules;
  }

  static List<WorkSchedule> getSchedulesForDate(DateTime date) {
    return getWorkSchedules().where((schedule) => 
      schedule.date.year == date.year &&
      schedule.date.month == date.month &&
      schedule.date.day == date.day
    ).toList();
  }

  static List<WorkSchedule> getSchedulesForMonth(DateTime month) {
    return getWorkSchedules().where((schedule) => 
      schedule.date.year == month.year &&
      schedule.date.month == month.month
    ).toList();
  }

  static WorkSchedule? getTodaySchedule() {
    final today = DateTime.now();
    final schedules = getSchedulesForDate(today);
    return schedules.isNotEmpty ? schedules.first : null;
  }

  static List<WorkSchedule> getUpcomingSchedules({int days = 7}) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    
    return getWorkSchedules().where((schedule) => 
      schedule.date.isAfter(now) && 
      schedule.date.isBefore(endDate)
    ).toList();
  }

  static Map<String, int> getMonthlyStats(DateTime month) {
    final schedules = getSchedulesForMonth(month);
    final stats = <String, int>{
      'task': 0,
      'meeting': 0,
    };

    for (final schedule in schedules) {
      stats[schedule.type] = (stats[schedule.type] ?? 0) + 1;
    }

    return stats;
  }

  static int getTotalWorkHours(DateTime month) {
    final schedules = getSchedulesForMonth(month);
    int totalMinutes = 0;

    for (final schedule in schedules) {
      if (schedule.type == 'task' || schedule.type == 'meeting') {
        totalMinutes += schedule.workDuration.inMinutes;
      }
    }

    return totalMinutes ~/ 60; // Convert to hours
  }
}
