import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/storage_service.dart';

/// Controller for managing app settings and user profile
class SettingsController with ChangeNotifier {
  final StorageService _storageService;

  /// User profile data
  late UserProfile _userProfile;

  /// Theme mode (light, dark, system)
  ThemeMode _themeMode = ThemeMode.system;

  /// Constructor for settings controller
  SettingsController(this._storageService) {
    _loadSettings();
  }

  /// Get current user profile
  UserProfile get userProfile => _userProfile;

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if dark theme is active (used for UI rendering decisions)
  bool isDarkTheme(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        final brightness = MediaQuery.of(context).platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    int? dailyGoal,
    double? weight,
    ActivityLevel? activityLevel,
    bool? notificationsEnabled,
  }) async {
    _userProfile = _userProfile.copyWith(
      dailyGoal: dailyGoal,
      weight: weight,
      activityLevel: activityLevel,
      notificationsEnabled: notificationsEnabled,
    );

    await _storageService.saveUserProfile(_userProfile);
    notifyListeners();
  }

  /// Calculate recommended water intake based on user profile
  int getRecommendedIntake() {
    return _userProfile.calculateRecommendedIntake();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    // Save theme preference
    bool? isDark;
    if (mode == ThemeMode.dark) {
      isDark = true;
    } else if (mode == ThemeMode.light) {
      isDark = false;
    }

    if (isDark != null) {
      await _storageService.saveThemePreference(isDark);
    }

    notifyListeners();
  }

  /// Load settings from storage
  void _loadSettings() {
    // Load user profile
    _userProfile = _storageService.getUserProfile();

    // Load theme preference
    final isDark = _storageService.getThemePreference();
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
  }
}
