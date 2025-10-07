import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection_container.dart' as di;
import 'core/providers/stream_video_provider.dart';
import '/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables (optional)
  // try {
  //   await dotenv.load(fileName: ".env");
  // } catch (e) {
  //   print('Warning: .env file not found, using default values');
  // }
  
  // Initialize dependency injection
  await di.init();
  
  runApp(
    const ProviderScope(
      // bọc app trong ProviderScope
      child: StreamVideoProvider(
        child: MyApp(),
      ),
    ),
  );
}
