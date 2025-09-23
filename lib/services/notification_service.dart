/// Stub implementation of NotificationService
/// This is a placeholder that doesn't actually implement notifications
/// as per the requirement "dont implement notification function"
class NotificationService {
  /// Initialize the notification service
  Future<void> init() async {
    // No implementation as requested
  }

  /// Request notification permissions (stub)
  Future<bool> requestPermissions() async {
    // Always return true as if permissions were granted
    return true;
  }

  /// Cancel all scheduled reminders (stub)
  Future<void> cancelAllReminders() async {
    // No implementation as requested
  }

  /// Schedule a single reminder (stub)
  Future<void> scheduleReminder(DateTime scheduledTime,
      {String? customMessage}) async {
    // No implementation as requested
  }

  /// Schedule multiple notifications (stub)
  Future<void> scheduleNotifications(List<dynamic> reminderTimes) async {
    // No implementation as requested
  }

  /// Show a water consumption notification (stub)
  Future<void> showWaterConsumptionNotification(int amount) async {
    // No implementation as requested
  }
}
