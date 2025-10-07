import 'package:stream_video_flutter/stream_video_flutter.dart';
import '../../domain/repositories/meeting_repository.dart';
import '../datasources/remote_datasource.dart';

/// Implementation of meeting repository using remote data source
class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingRemoteDataSource _remoteDataSource;
  
  MeetingRepositoryImpl({required MeetingRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;
  
  @override
  Future<QueriedCall?> getMeetingById(String id) async {
    try {
      return await _remoteDataSource.getMeetingById(id);
    } catch (e) {
      // Log error and return null
      print('Error getting meeting by ID: $e');
      return null;
    }
  }
  
  @override
  Future<List<QueriedCall>> getUserMeetings() async {
    try {
      return await _remoteDataSource.getUserMeetings();
    } catch (e) {
      // Log error and return empty list
      print('Error getting user meetings: $e');
      return [];
    }
  }
}
