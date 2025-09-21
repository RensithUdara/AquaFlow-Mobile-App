import 'package:flutter/foundation.dart';
import '../models/notification_settings.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

/// Controller for managing notification functionality
class NotificationController with ChangeNotifier {
  final NotificationService _notificationService;
  final StorageService _storageService;
  
  /// Current notification settings
  late NotificationSettings _settings;
  
  /// Constructor for notification controller
  NotificationController(this._notificationService, this._storageService) {
    _loadSettings();
  }

  /// Get current notification settings
  NotificationSettings get settings => _settings;
  
  /// Get whether notifications are enabled
  bool get isEnabled => _settings.isEnabled;
  
  /// Get reminder times
  List<ReminderTime> get reminderTimes => _settings.reminderTimes;
  
  /// Get whether smart reminders are enabled
  bool get smartRemindersEnabled => _settings.smartRemindersEnabled;

  /// Toggle notifications on/off
  Future<void> toggleNotifications(bool value) async {
    _settings = _settings.copyWith(isEnabled: value);
    
    if (value) {
      // Request permissions if enabling notifications
      await _notificationService.requestPermissions();
      
      // Schedule reminders
      await _scheduleReminders();
    } else {
      // Cancel all reminders if disabling notifications
      await _notificationService.cancelAllReminders();
    }
    
    await _saveSettings();
  }

  /// Toggle smart reminders on/off
  Future<void> toggleSmartReminders(bool value) async {
    _settings = _settings.copyWith(smartRemindersEnabled: value);
    await _saveSettings();
    
    if (_settings.isEnabled) {
      await _scheduleReminders();
    }
  }

  /// Add a new reminder time
  Future<void> addReminderTime(int hour, int minute) async {
    final newTime = ReminderTime(hour: hour, minute: minute);
    
    final List<ReminderTime> updatedTimes = List.from(_settings.reminderTimes)
      ..add(newTime);
    
    _settings = _settings.copyWith(reminderTimes: updatedTimes);
    await _saveSettings();
    
    if (_settings.isEnabled) {
      await _scheduleReminders();
    }
  }

  /// Update an existing reminder time
  Future<void> updateReminderTime(int index, {int? hour, int? minute, bool? isEnabled}) async {
    if (index < 0 || index >= _settings.reminderTimes.length) return;
    
    final currentTime = _settings.reminderTimes[index];
    final updatedTime = ReminderTime(
      hour: hour ?? currentTime.hour,
      minute: minute ?? currentTime.minute,
      isEnabled: isEnabled ?? currentTime.isEnabled,
    );
    
    final List<ReminderTime> updatedTimes = List.from(_settings.reminderTimes);
    updatedTimes[index] = updatedTime;
    
    _settings = _settings.copyWith(reminderTimes: updatedTimes);
    await _saveSettings();
    
    if (_settings.isEnabled) {
      await _scheduleReminders();
    }
  }

  /// Remove a reminder time
  Future<void> removeReminderTime(int index) async {
    if (index < 0 || index >= _settings.reminderTimes.length) return;
    
    final List<ReminderTime> updatedTimes = List.from(_settings.reminderTimes);
    updatedTimes.removeAt(index);
    
    _settings = _settings.copyWith(reminderTimes: updatedTimes);
    await _saveSettings();
    
    if (_settings.isEnabled) {
      await _scheduleReminders();
    }
  }

  /// Set quiet hours
  Future<void> setQuietHours(ReminderTime start, ReminderTime end) async {
    _settings = _settings.copyWith(
      quietHoursStart: start,
      quietHoursEnd: end,
    );
    
    await _saveSettings();
    
    if (_settings.isEnabled) {
      await _scheduleReminders();
    }
  }

  /// Reset to default notification settings
  Future<void> resetToDefaults() async {
    _settings = NotificationSettings.defaultSettings();
    await _saveSettings();
    
    if (_settings.isEnabled) {
      await _scheduleReminders();
    }
  }

  /// Schedule a smart reminder based on current progress
  Future<void> scheduleSmartReminder(int currentIntake, int targetIntake) async {
    if (!_settings.isEnabled || !_settings.smartRemindersEnabled) return;
    
    await _notificationService.scheduleSmartReminder(
      _settings,
      DateTime.now(),
      currentIntake,
      targetIntake,
    );
  }

  /// Refresh notification schedule
  Future<void> refreshSchedule() async {
    if (!_settings.isEnabled) return;
    
    // Cancel all existing reminders
    await _notificationService.cancelAllReminders();
    
    // Schedule new reminders
    await _scheduleReminders();
  }

  /// Schedule reminders based on current settings
  Future<void> _scheduleReminders() async {
    await _notificationService.scheduleRemindersForDay(_settings, DateTime.now());
  }

  /// Load notification settings from storage
  void _loadSettings() {
    _settings = _storageService.getNotificationSettings();
  }

  /// Save notification settings to storage
  Future<void> _saveSettings() async {
    await _storageService.saveNotificationSettings(_settings);
    notifyListeners();
  }

  /// Initialize notifications
  Future<void> initialize() async {
    if (_settings.isEnabled) {
      await _notificationService.requestPermissions();
      await _scheduleReminders();
    }
  }
}