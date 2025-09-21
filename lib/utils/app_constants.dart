/// Constants used throughout the app
class AppConstants {
  // App Information
  static const String appName = 'AquaFlow';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String notificationSettingsKey = 'notification_settings';
  static const String dailyGoalKey = 'daily_goal';
  static const String waterEntriesKey = 'water_entries';
  static const String themePreferenceKey = 'theme_preference';
  
  // Default Values
  static const int defaultDailyGoalMl = 2500;
  static const List<int> quickAddAmounts = [100, 250, 500, 750, 1000];
  
  // Units
  static const String mlUnit = 'ml';
  static const String ozUnit = 'oz';
  
  // Notification Channels
  static const String reminderChannelId = 'water_reminders';
  static const String reminderChannelName = 'Water Reminders';
  static const String reminderChannelDescription = 'Notifications to remind you to drink water';
  
  // Achievement Thresholds
  static const int streakAchievementDays = 7;
  static const double goalCompletionPercentage = 1.0;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  // UI Constants
  static const double borderRadius = 16.0;
  static const double cardElevation = 4.0;
  static const double contentPadding = 16.0;
  
  // Navigation Routes
  static const String homeRoute = '/';
  static const String addWaterRoute = '/add-water';
  static const String historyRoute = '/history';
  static const String settingsRoute = '/settings';
  static const String notificationsRoute = '/notifications';
  static const String profileRoute = '/profile';
  
  // Conversion Factors
  static const double mlToOzFactor = 0.033814;  // 1 ml = 0.033814 oz
  static const double ozToMlFactor = 29.5735;   // 1 oz = 29.5735 ml
}