import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_goal.dart';
import '../models/notification_settings.dart';
import '../models/user_profile.dart';
import '../models/water_analytics.dart';
import '../models/water_entry.dart';
import '../utils/app_constants.dart';

/// Service for handling local storage operations
class StorageService {
  late SharedPreferences _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save the user profile to local storage
  Future<bool> saveUserProfile(UserProfile profile) async {
    return await _prefs.setString(
        AppConstants.userProfileKey, jsonEncode(profile.toJson()));
  }

  /// Get the user profile from local storage
  UserProfile getUserProfile() {
    final profileString = _prefs.getString(AppConstants.userProfileKey);
    if (profileString != null) {
      try {
        return UserProfile.fromJson(jsonDecode(profileString));
      } catch (e) {
        // Return default profile if there's an error parsing stored data
        return UserProfile.defaultProfile();
      }
    }
    return UserProfile.defaultProfile();
  }

  /// Save notification settings to local storage
  Future<bool> saveNotificationSettings(NotificationSettings settings) async {
    return await _prefs.setString(
        AppConstants.notificationSettingsKey, jsonEncode(settings.toJson()));
  }

  /// Get notification settings from local storage
  NotificationSettings getNotificationSettings() {
    final settingsString =
        _prefs.getString(AppConstants.notificationSettingsKey);
    if (settingsString != null) {
      try {
        return NotificationSettings.fromJson(jsonDecode(settingsString));
      } catch (e) {
        // Return default settings if there's an error parsing stored data
        return NotificationSettings.defaultSettings();
      }
    }
    return NotificationSettings.defaultSettings();
  }

  /// Save daily goal to local storage
  Future<bool> saveDailyGoal(DailyGoal goal) async {
    final key = '${AppConstants.dailyGoalKey}_${_formatDate(goal.date)}';
    return await _prefs.setString(key, jsonEncode(goal.toJson()));
  }

  /// Get daily goal for a specific date from local storage
  DailyGoal? getDailyGoal(DateTime date) {
    final key = '${AppConstants.dailyGoalKey}_${_formatDate(date)}';
    final goalString = _prefs.getString(key);
    if (goalString != null) {
      try {
        return DailyGoal.fromJson(jsonDecode(goalString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Save water entries for a specific date to local storage
  Future<bool> saveWaterEntries(DateTime date, List<WaterEntry> entries) async {
    final key = '${AppConstants.waterEntriesKey}_${_formatDate(date)}';
    final entriesJson = entries.map((entry) => entry.toJson()).toList();
    return await _prefs.setString(key, jsonEncode(entriesJson));
  }

  /// Get water entries for a specific date from local storage
  List<WaterEntry> getWaterEntries(DateTime date) {
    final key = '${AppConstants.waterEntriesKey}_${_formatDate(date)}';
    final entriesString = _prefs.getString(key);
    if (entriesString != null) {
      try {
        final List<dynamic> entriesJson = jsonDecode(entriesString);
        return entriesJson.map((json) => WaterEntry.fromJson(json)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  /// Save theme preference to local storage
  Future<bool> saveThemePreference(bool isDarkMode) async {
    return await _prefs.setBool(AppConstants.themePreferenceKey, isDarkMode);
  }

  /// Get theme preference from local storage
  bool? getThemePreference() {
    return _prefs.getBool(AppConstants.themePreferenceKey);
  }

  /// Get all dates that have water entries
  List<DateTime> getAllDatesWithEntries() {
    final List<DateTime> dates = [];
    final allKeys = _prefs.getKeys();

    for (final key in allKeys) {
      if (key.startsWith(AppConstants.waterEntriesKey)) {
        final dateStr = key.substring(AppConstants.waterEntriesKey.length + 1);
        try {
          final parts = dateStr.split('_');
          if (parts.length == 3) {
            final year = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);
            dates.add(DateTime(year, month, day));
          }
        } catch (e) {
          // Skip invalid date
        }
      }
    }

    // Sort dates in descending order (newest first)
    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }

  /// Get all water entries between start and end dates
  Future<List<WaterEntry>> getWaterEntriesForPeriod(
      DateTime start, DateTime end) async {
    final entries = <WaterEntry>[];
    var current = start;

    while (!current.isAfter(end)) {
      entries.addAll(getWaterEntries(current));
      current = current.add(const Duration(days: 1));
    }

    return entries;
  }

  /// Get all daily goals between start and end dates
  Future<List<DailyGoal>> getDailyGoalsForPeriod(
      DateTime start, DateTime end) async {
    final goals = <DailyGoal>[];
    var current = start;

    while (!current.isAfter(end)) {
      final goal = getDailyGoal(current);
      if (goal != null) {
        goals.add(goal);
      }
      current = current.add(const Duration(days: 1));
    }

    return goals;
  }

  /// Save analytics data to local storage
  Future<bool> saveAnalytics(WaterAnalytics analytics) async {
    final key =
        '${AppConstants.analyticsKey}_${_formatDate(analytics.startDate)}_${_formatDate(analytics.endDate)}';
    return await _prefs.setString(key, jsonEncode(analytics.toJson()));
  }

  /// Get analytics data from local storage
  WaterAnalytics? getAnalytics(DateTime start, DateTime end) {
    final key =
        '${AppConstants.analyticsKey}_${_formatDate(start)}_${_formatDate(end)}';
    final analyticsString = _prefs.getString(key);
    if (analyticsString != null) {
      try {
        return WaterAnalytics.fromJson(jsonDecode(analyticsString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Clear all data from local storage
  Future<bool> clearAllData() async {
    return await _prefs.clear();
  }

  /// Helper method to format date as string
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
