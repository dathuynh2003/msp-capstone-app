import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fcm_service.dart';

// Provider cho FCM Service singleton
final fcmServiceProvider = Provider<FCMService>((ref) {
  throw UnimplementedError('FCMService must be overridden in main.dart');
});
