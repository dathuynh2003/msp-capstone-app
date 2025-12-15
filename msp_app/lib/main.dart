import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/background_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/fcm_service_provider.dart'; // THÊM DÒNG NÀY
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

  runApp(
    ProviderScope(
      overrides: [fcmServiceProvider.overrideWithValue(fcmService)],
      child: const MyApp(),
    ),
  );
}
