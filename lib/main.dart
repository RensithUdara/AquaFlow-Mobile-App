import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/history_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/water_tracking_controller.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'utils/app_constants.dart';
import 'utils/app_theme.dart';
import 'views/app_scaffold.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final storageService = StorageService();
  await storageService.init();
  
  // Create notification service (stub implementation)
  final notificationService = NotificationService();

  runApp(
    MyApp(
      storageService: storageService,
      notificationService: notificationService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final NotificationService notificationService;

  const MyApp({
    super.key,
    required this.storageService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Register controllers
        ChangeNotifierProvider(
          create: (_) => SettingsController(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => WaterTrackingController(storageService),
        ),
        // Simplified NotificationController that doesn't implement notification functionality
        ChangeNotifierProvider(
          create: (_) =>
              NotificationController(NotificationService(), storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryController(storageService),
        ),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settingsController, _) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: AppTheme.getLightTheme(),
            darkTheme: AppTheme.getDarkTheme(),
            themeMode: settingsController.themeMode,
            home: const AppScaffold(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
