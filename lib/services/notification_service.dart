class NotificationService {
  Future<void> init() async {}
  Future<bool> requestPermissions() async { return false; }
  Future<void> cancelAllReminders() async {}
  Future<void> scheduleReminder(DateTime scheduledTime, {String? customMessage}) async {}
  Future<void> scheduleNotifications(List<dynamic> reminderTimes) async {}
  Future<void> showWaterConsumptionNotification(int amount) async {}
}
