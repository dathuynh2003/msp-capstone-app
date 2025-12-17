import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/services/background_service.dart';
import 'core/routes/route_generator.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        debugPrint('📴 [App Lifecycle] App paused (background)');
        break;
      case AppLifecycleState.resumed:
        debugPrint('📱 [App Lifecycle] App resumed (foreground)');
        break;
      case AppLifecycleState.inactive:
        debugPrint('⏸️ [App Lifecycle] App inactive');
        break;
      case AppLifecycleState.detached:
        debugPrint('🔌 [App Lifecycle] App detached');
        break;
      case AppLifecycleState.hidden:
        debugPrint('👻 [App Lifecycle] App hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng MSP',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      navigatorKey: BackgroundServiceHelper.navigatorKey,
      home: const AuthWrapper(),
      onGenerateRoute: RouteGenerator.generateRoute, // Dùng RouteGenerator
      debugShowCheckedModeBanner: false,
      navigatorObservers: [_AppNavigatorObserver()],
    );
  }
}

class _AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint('🧭 [Navigation] PUSH: ${route.settings.name ?? 'Unknown'}');
    if (route.settings.arguments != null) {
      debugPrint('📦 [Navigation] Arguments: ${route.settings.arguments}');
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('🧭 [Navigation] POP: ${route.settings.name ?? 'Unknown'}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
      '🧭 [Navigation] REPLACE: ${oldRoute?.settings.name} → ${newRoute?.settings.name}',
    );
  }
}
