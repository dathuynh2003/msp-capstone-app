import 'attendee_response.dart';

class GetMeetingResponse {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final String createdById;
  final String createdByEmail;
  final String projectId;
  final String projectName;
  final String? milestoneId;
  final String? milestoneName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? recordUrl;
  final String? transcription;
  final String? summary;
  final List<AttendeeResponse> attendees;

  GetMeetingResponse({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.createdById,
    required this.createdByEmail,
    required this.projectId,
    required this.projectName,
    this.milestoneId,
    this.milestoneName,
    required this.createdAt,
    required this.updatedAt,
    this.recordUrl,
    this.transcription,
    this.summary,
    required this.attendees,
  });

  factory GetMeetingResponse.fromJson(Map<String, dynamic> json) =>
      GetMeetingResponse(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'],
        startTime: DateTime.parse(json['startTime']),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'])
            : null,
        status: json['status'] ?? '',
        createdById: json['createdById'],
        createdByEmail: json['createdByEmail'] ?? '',
        projectId: json['projectId'],
        projectName: json['projectName'] ?? '',
        milestoneId: json['milestoneId'],
        milestoneName: json['milestoneName'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        recordUrl: json['recordUrl'],
        transcription: json['transcription'],
        summary: json['summary'],
        attendees: (json['attendees'] as List<dynamic>)
            .map((e) => AttendeeResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
