// Notification service temporarily disabled
// Imports commented out due to package compatibility issues
// import 'dart:math';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz_data;
// import 'package:timezone/timezone.dart' as tz;

import '../models/notification_settings.dart';
import '../utils/app_constants.dart';

/// Stub service for managing app notifications - temporarily disabled due to package compatibility issues
class NotificationService {
  // Stub implementation with no-op methods to maintain interface compatibility

  /// Initialize the notification service
  Future<void> init() async {
    // No-op implementation
    print('Notifications temporarily disabled');
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    // Always return false since notifications are disabled
    return false;
  }

  /// Schedule a water reminder notification
  Future<void> scheduleReminder(DateTime scheduledTime,
      {String? customMessage}) async {
    // No-op implementation
  }

  /// Initialize the notification service
  Future<void> init() async {
    // Initialize timezone data
    tz_data.initializeTimeZones();

    // Initialize Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize iOS settings
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize settings for all platforms
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    // Initialize notifications plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create the notification channel for Android
    await _createNotificationChannel();
  }

  /// Create the notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      description: AppConstants.reminderChannelDescription,
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    // Request permissions for iOS
    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? false;
  }

  /// Schedule a water reminder notification
  Future<void> scheduleReminder(DateTime scheduledTime,
      {String? customMessage}) async {
    final int notificationId = Random().nextInt(100000);
    const String title = 'Hydration Reminder';
    final String body = customMessage ?? _getRandomReminderMessage();

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      channelDescription: AppConstants.reminderChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule multiple reminders based on notification settings
  Future<void> scheduleRemindersForDay(
      NotificationSettings settings, DateTime date) async {
    // Cancel any existing scheduled reminders
    await cancelAllReminders();

    // Skip if notifications are not enabled
    if (!settings.isEnabled) return;

    // Get reminder schedule for the day
    final List<DateTime> reminderTimes =
        settings.generateReminderSchedule(date);

    // Schedule each reminder
    for (final reminderTime in reminderTimes) {
      // Skip quiet hours
      if (settings.isQuietHours(reminderTime)) continue;

      await scheduleReminder(reminderTime);
    }
  }

  /// Generate a smart reminder based on activity and time of day
  Future<void> scheduleSmartReminder(
    NotificationSettings settings,
    DateTime date,
    int currentIntake,
    int targetIntake,
  ) async {
    // Skip if notifications or smart reminders are not enabled
    if (!settings.isEnabled || !settings.smartRemindersEnabled) return;

    final now = DateTime.now();
    final progress = currentIntake / targetIntake;

    // Early morning reminder (8-10 AM)
    if (now.hour >= 8 && now.hour < 10 && progress < 0.1) {
      await scheduleReminder(
        now.add(const Duration(minutes: 30)),
        customMessage: 'Start your day with a glass of water! 💧',
      );
    }
    // Mid-morning reminder (10 AM - 12 PM)
    else if (now.hour >= 10 && now.hour < 12 && progress < 0.25) {
      await scheduleReminder(
        now.add(const Duration(minutes: 30)),
        customMessage: 'Keep your energy up with a hydration break! 💦',
      );
    }
    // Lunch reminder (12 PM - 2 PM)
    else if (now.hour >= 12 && now.hour < 14 && progress < 0.5) {
      await scheduleReminder(
        now.add(const Duration(minutes: 30)),
        customMessage: 'Have a glass of water with your lunch! 🥤',
      );
    }
    // Afternoon reminder (2 PM - 5 PM)
    else if (now.hour >= 14 && now.hour < 17 && progress < 0.7) {
      await scheduleReminder(
        now.add(const Duration(minutes: 30)),
        customMessage: 'Combat the afternoon slump with water! 💧',
      );
    }
    // Evening reminder (5 PM - 8 PM)
    else if (now.hour >= 17 && now.hour < 20 && progress < 0.9) {
      await scheduleReminder(
        now.add(const Duration(minutes: 30)),
        customMessage: 'Almost there! Stay hydrated through the evening! 💦',
      );
    }
    // Night reminder (8 PM - 10 PM)
    else if (now.hour >= 20 && now.hour < 22 && progress < 1.0) {
      await scheduleReminder(
        now.add(const Duration(minutes: 30)),
        customMessage: 'Last chance to complete your daily goal! 🎯',
      );
    }
  }

  /// Send an immediate notification
  Future<void> showNotification(String title, String body) async {
    final int notificationId = Random().nextInt(100000);

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      channelDescription: AppConstants.reminderChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
    );
  }

  /// Cancel all scheduled reminders
  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // This can be used to navigate to specific screens when user taps on notification
  }

  /// Get a random reminder message
  String _getRandomReminderMessage() {
    final List<String> messages = [
      'Time for a hydration break! 💧',
      'Stay hydrated, stay healthy! 🥤',
      'Your body needs water! 💦',
      "Don't forget to drink water! 💧",
      'Hydration reminder! 🚰',
      'Take a sip of water now! 💧',
      'Water break time! 💦',
      'Keep your hydration on track! 🥤',
      'Refill your water bottle! 🚰',
      'Drink up! Your body will thank you! 💧',
    ];

    return messages[Random().nextInt(messages.length)];
  }
}
