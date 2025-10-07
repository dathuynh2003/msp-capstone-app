import '../entities/meeting.dart';

class MeetingMockData {
  static List<Meeting> getMeetings() {
    final now = DateTime.now();
    
    return [
      // Upcoming meetings
      Meeting(
        id: 'm1',
        title: 'Sprint Planning Meeting',
        description: 'Weekly sprint planning session to discuss upcoming tasks and priorities.',
        startTime: now.add(const Duration(hours: 2)), // 2 hours from now
        endTime: now.add(const Duration(hours: 3)),
        participantIds: ['user1', 'user2', 'user3', 'user4'],
        participantNames: ['John Doe', 'Sarah Johnson', 'Mike Chen', 'Emily Davis'],
        organizerId: 'user2',
        organizerName: 'Sarah Johnson',
        meetingLink: 'https://meet.google.com/abc-defg-hij',
        status: 'scheduled',
        meetingType: 'online',
        location: 'Google Meet',
        color: 'FF5E13',
        agenda: '1. Review previous sprint\n2. Plan new tasks\n3. Assign responsibilities\n4. Set deadlines',
        attachments: ['sprint_plan.pdf', 'task_list.xlsx'],
      ),
      
      Meeting(
        id: 'm2',
        title: 'Project Review & Demo',
        description: 'Monthly project review meeting with stakeholders and demo of current progress.',
        startTime: now.add(const Duration(days: 1, hours: 10)), // Tomorrow 10 AM
        endTime: now.add(const Duration(days: 1, hours: 11, minutes: 30)),
        participantIds: ['user1', 'user2', 'user3', 'user4', 'user5'],
        participantNames: ['John Doe', 'Sarah Johnson', 'Mike Chen', 'Emily Davis', 'Alex Rodriguez'],
        organizerId: 'user1',
        organizerName: 'John Doe',
        meetingLink: 'https://zoom.us/j/123456789',
        status: 'scheduled',
        meetingType: 'online',
        location: 'Zoom',
        color: 'FFA463',
        agenda: '1. Project status update\n2. Demo new features\n3. Q&A session\n4. Next month planning',
        attachments: ['project_report.pdf', 'demo_script.docx'],
      ),
      
      // Meeting starting soon (within 15 minutes)
      Meeting(
        id: 'm3',
        title: 'Daily Standup',
        description: 'Daily standup meeting to sync on progress and blockers.',
        startTime: now.add(const Duration(minutes: 10)), // 10 minutes from now
        endTime: now.add(const Duration(minutes: 25)),
        participantIds: ['user1', 'user2', 'user3'],
        participantNames: ['John Doe', 'Sarah Johnson', 'Mike Chen'],
        organizerId: 'user3',
        organizerName: 'Mike Chen',
        meetingLink: 'https://teams.microsoft.com/l/meetup-join/123456789',
        status: 'scheduled',
        meetingType: 'online',
        location: 'Microsoft Teams',
        color: 'FFDBBD',
        agenda: '1. Yesterday accomplishments\n2. Today plans\n3. Blockers discussion',
        attachments: [],
      ),
      
      // Ongoing meeting
      Meeting(
        id: 'm4',
        title: 'Code Review Session',
        description: 'Code review session for the latest features implementation.',
        startTime: now.subtract(const Duration(minutes: 30)), // Started 30 minutes ago
        endTime: now.add(const Duration(minutes: 30)), // Ends in 30 minutes
        participantIds: ['user1', 'user2', 'user4'],
        participantNames: ['John Doe', 'Sarah Johnson', 'Emily Davis'],
        organizerId: 'user2',
        organizerName: 'Sarah Johnson',
        meetingLink: 'https://meet.google.com/xyz-1234-abc',
        status: 'ongoing',
        meetingType: 'online',
        location: 'Google Meet',
        color: 'FDF0D2',
        agenda: '1. Review pull requests\n2. Discuss code quality\n3. Plan improvements',
        attachments: ['pr_review.md', 'code_standards.pdf'],
      ),
      
      // Completed meeting
      Meeting(
        id: 'm5',
        title: 'Client Feedback Session',
        description: 'Meeting with client to gather feedback on current features.',
        startTime: now.subtract(const Duration(hours: 2)), // 2 hours ago
        endTime: now.subtract(const Duration(hours: 1)), // 1 hour ago
        participantIds: ['user1', 'user2', 'user5'],
        participantNames: ['John Doe', 'Sarah Johnson', 'Alex Rodriguez'],
        organizerId: 'user1',
        organizerName: 'John Doe',
        meetingLink: 'https://zoom.us/j/987654321',
        status: 'completed',
        meetingType: 'online',
        location: 'Zoom',
        color: 'FF5E13',
        agenda: '1. Present current features\n2. Gather client feedback\n3. Discuss next steps',
        attachments: ['client_feedback.docx', 'feature_demo.mp4'],
      ),
      
      // Future meeting
      Meeting(
        id: 'm6',
        title: 'Architecture Planning',
        description: 'Technical architecture planning session for upcoming features.',
        startTime: now.add(const Duration(days: 3, hours: 14)), // 3 days from now, 2 PM
        endTime: now.add(const Duration(days: 3, hours: 16)),
        participantIds: ['user2', 'user3', 'user4'],
        participantNames: ['Sarah Johnson', 'Mike Chen', 'Emily Davis'],
        organizerId: 'user3',
        organizerName: 'Mike Chen',
        meetingLink: 'https://meet.google.com/arch-1234-plan',
        status: 'scheduled',
        meetingType: 'online',
        location: 'Google Meet',
        color: 'FFA463',
        agenda: '1. Review current architecture\n2. Plan new components\n3. Discuss scalability\n4. Assign tasks',
        attachments: ['current_arch.pdf', 'requirements.docx'],
      ),
    ];
  }
}
