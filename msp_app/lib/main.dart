import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection_container.dart' as di;
import 'core/providers/stream_video_provider.dart';
import '/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.setupDI();

  runApp(const ProviderScope(child: StreamVideoProvider(child: MyApp())));
}
