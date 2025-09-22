import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/history_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/water_tracking_controller.dart';
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

  runApp(
    MyApp(
      storageService: storageService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({
    super.key,
    required this.storageService,
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
        // Notification controller temporarily disabled
        // ChangeNotifierProvider(
        //   create: (_) =>
        //       NotificationController(notificationService, storageService),
        // ),
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
