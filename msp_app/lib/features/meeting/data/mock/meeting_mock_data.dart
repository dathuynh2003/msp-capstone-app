import '../../domain/entities/meeting.dart';
import '../../domain/entities/project.dart';

class MeetingMockData {
  static List<Meeting> getMeetings() {
    return [
      Meeting(
        id: 'meeting_1',
        name: 'Daily Standup Meeting',
        description: 'Daily standup with development team to discuss progress and blockers',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
        status: 'scheduled',
        creatorId: 'user_1',
        creatorName: 'Nguyễn Văn A',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        projectId: 'project_1',
        project: _getProject1(),
        participantIds: ['user_1', 'user_2', 'user_3', 'user_4'],
        participantNames: ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D'],
        milestoneIds: ['milestone_1', 'milestone_2'],
        meetingLink: 'https://meet.google.com/abc-defg-hij',
        notes: 'Chuẩn bị demo cho client vào tuần sau',
      ),
      Meeting(
        id: 'meeting_2',
        name: 'Sprint Planning Meeting',
        description: 'Planning for next sprint with all team members',
        startTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 11)),
        status: 'scheduled',
        creatorId: 'user_2',
        creatorName: 'Trần Thị B',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        projectId: 'project_1',
        project: _getProject1(),
        participantIds: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5'],
        participantNames: ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D', 'Hoàng Văn E'],
        milestoneIds: ['milestone_2', 'milestone_3'],
        notes: 'Review backlog và estimate story points',
      ),
      Meeting(
        id: 'meeting_3',
        name: 'Client Review Meeting',
        description: 'Review project progress with client and collect feedback',
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        status: 'ongoing',
        creatorId: 'user_1',
        creatorName: 'Nguyễn Văn A',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        projectId: 'project_2',
        project: _getProject2(),
        participantIds: ['user_1', 'user_2', 'client_1'],
        participantNames: ['Nguyễn Văn A', 'Trần Thị B', 'Client ABC'],
        milestoneIds: ['milestone_4'],
        meetingLink: 'https://meet.google.com/client-review-123',
        notes: 'Demo tính năng mới cho client',
      ),
      Meeting(
        id: 'meeting_4',
        name: 'Code Review Session',
        description: 'Review code changes and discuss improvements',
        startTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        status: 'finished',
        creatorId: 'user_3',
        creatorName: 'Lê Văn C',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        projectId: 'project_1',
        project: _getProject1(),
        participantIds: ['user_1', 'user_3', 'user_4'],
        participantNames: ['Nguyễn Văn A', 'Lê Văn C', 'Phạm Thị D'],
        milestoneIds: ['milestone_1'],
        meetingLink: null,
        notes: 'Review PR #123 và #124',
      ),
      // Hard-coded meeting for testing Stream API integration
      Meeting(
        id: 'b558c91d-edc1-48d5-9bdd-738c977726bd',
        name: 'Stream API Test Meeting',
        description: 'Meeting để test Stream API integration',
        startTime: DateTime.now().add(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        status: 'scheduled',
        creatorId: 'user_1',
        creatorName: 'Nguyễn Văn A',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        projectId: 'project_1',
        project: _getProject1(),
        participantIds: ['user_1', 'user_2', 'user_3'],
        participantNames: ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C'],
        milestoneIds: ['milestone_1'],
        meetingLink: 'https://stream.io/test-meeting',
        notes: 'Test meeting cho Stream API integration',
      ),
    ];
  }

  static Meeting? getMeetingById(String id) {
    return getMeetings().where((meeting) => meeting.id == id).firstOrNull;
  }

  static List<Meeting> getMeetingsByProjectId(String projectId) {
    return getMeetings().where((meeting) => meeting.projectId == projectId).toList();
  }

  static List<Meeting> getUpcomingMeetings() {
    final now = DateTime.now();
    return getMeetings().where((meeting) => meeting.startTime.isAfter(now)).toList();
  }

  static List<Meeting> getOngoingMeetings() {
    final now = DateTime.now();
    return getMeetings().where((meeting) => 
      meeting.startTime.isBefore(now) && meeting.endTime.isAfter(now)
    ).toList();
  }

  static Project _getProject1() {
    return Project(
      id: 'project_1',
      name: 'E-commerce Platform Development',
      description: 'Phát triển nền tảng thương mại điện tử với các tính năng thanh toán, quản lý sản phẩm và đơn hàng',
      status: 'in_progress',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      managerId: 'user_1',
      managerName: 'Nguyễn Văn A',
      memberIds: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5'],
      memberNames: ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D', 'Hoàng Văn E'],
      milestones: [
        Milestone(
          id: 'milestone_1',
          name: 'Setup Project Infrastructure',
          description: 'Thiết lập cơ sở hạ tầng dự án, database, CI/CD',
          status: 'completed',
          dueDate: DateTime.now().subtract(const Duration(days: 45)),
          completedDate: DateTime.now().subtract(const Duration(days: 50)),
        ),
        Milestone(
          id: 'milestone_2',
          name: 'User Authentication System',
          description: 'Xây dựng hệ thống xác thực người dùng với JWT',
          status: 'in_progress',
          dueDate: DateTime.now().add(const Duration(days: 5)),
          completedDate: null,
        ),
        Milestone(
          id: 'milestone_3',
          name: 'Payment Gateway Integration',
          description: 'Tích hợp cổng thanh toán Stripe và VNPay',
          status: 'not_started',
          dueDate: DateTime.now().add(const Duration(days: 15)),
          completedDate: null,
        ),
      ],
    );
  }

  static Project _getProject2() {
    return Project(
      id: 'project_2',
      name: 'Mobile App Development',
      description: 'Phát triển ứng dụng di động cho iOS và Android với React Native',
      status: 'in_progress',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      managerId: 'user_2',
      managerName: 'Trần Thị B',
      memberIds: ['user_1', 'user_2', 'user_6'],
      memberNames: ['Nguyễn Văn A', 'Trần Thị B', 'Vũ Thị F'],
      milestones: [
        Milestone(
          id: 'milestone_4',
          name: 'UI/UX Design',
          description: 'Thiết kế giao diện người dùng và trải nghiệm',
          status: 'completed',
          dueDate: DateTime.now().subtract(const Duration(days: 10)),
          completedDate: DateTime.now().subtract(const Duration(days: 12)),
        ),
        Milestone(
          id: 'milestone_5',
          name: 'Core Features Development',
          description: 'Phát triển các tính năng cốt lõi của ứng dụng',
          status: 'in_progress',
          dueDate: DateTime.now().add(const Duration(days: 20)),
          completedDate: null,
        ),
      ],
    );
  }
}
