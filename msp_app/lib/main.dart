import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/background_service.dart';
import '/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo BGSerivice 1 lần duy nhất khi app khởi động
  await BackgroundServiceHelper.initialize();
  runApp(const ProviderScope(child: MyApp()));
}
