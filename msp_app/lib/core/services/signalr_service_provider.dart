import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'signalr_service.dart';

// Provider cho SignalR Service
final signalRServiceProvider = Provider<SignalRService>((ref) {
  final service = SignalRService();

  // Auto dispose khi provider bị hủy
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

// Provider để lắng nghe notification stream
final notificationStreamProvider = StreamProvider<dynamic>((ref) {
  final signalRService = ref.watch(signalRServiceProvider);
  return signalRService.notificationStream;
});

// Provider để lắng nghe unread count stream
final unreadCountStreamProvider = StreamProvider<int>((ref) {
  final signalRService = ref.watch(signalRServiceProvider);
  return signalRService.unreadCountStream;
});
