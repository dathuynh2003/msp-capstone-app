import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:msp_app/core/services/local_notification_service.dart';
import 'core/services/background_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/fcm_service_provider.dart';
import '/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('');
  debugPrint('========================================');
  debugPrint('🚀 [Main] App Initializing...');
  debugPrint('========================================');

  // 1. Initialize Firebase FIRST
  debugPrint('🔥 [Main] Initializing Firebase...');
  await Firebase.initializeApp();
  debugPrint('✅ [Main] Firebase initialized');

  // 2. Initialize Local Notifications SECOND (must be before FCM)
  debugPrint('🔔 [Main] Initializing Local Notifications...');
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();
  debugPrint('✅ [Main] Local Notifications initialized');

  // 3. Initialize Background Service (Stream Video)
  debugPrint('📹 [Main] Initializing Background Service...');
  await BackgroundServiceHelper.initialize();
  debugPrint('✅ [Main] Background Service initialized');

  // 4. Initialize FCM Service LAST
  debugPrint('📨 [Main] Initializing FCM...');
  final fcmService = FCMService();
  await fcmService.initialize();
  debugPrint('✅ [Main] FCM initialized');

  debugPrint('========================================');
  debugPrint('✅ [Main] All services initialized');
  debugPrint('========================================');
  debugPrint('');

  runApp(
    ProviderScope(
      overrides: [fcmServiceProvider.overrideWithValue(fcmService)],
      child: const MyApp(),
    ),
  );
}
