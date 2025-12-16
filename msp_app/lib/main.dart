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

  // 1. Initialize Firebase TRƯỚC TIÊN
  await Firebase.initializeApp();

  // 2. Initialize Background Service
  await BackgroundServiceHelper.initialize();

  // 3. Initialize FCM Service
  final fcmService = FCMService();
  await fcmService.initialize();

  // 4. Initialize Local Notifications
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [fcmServiceProvider.overrideWithValue(fcmService)],
      child: const MyApp(),
    ),
  );
}
