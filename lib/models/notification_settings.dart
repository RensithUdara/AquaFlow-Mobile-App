/// Model for representing notification time settings
class ReminderTime {
  /// Hour of the day (0-23)
  final int hour;

  /// Minute (0-59)
  final int minute;

  /// Whether this reminder is enabled
  final bool isEnabled;

  /// Constructor for creating a reminder time
  ReminderTime({
    required this.hour,
    required this.minute,
    this.isEnabled = true,
  });

  /// Format the time as a string in 24-hour format
  String get formattedTime {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Convert ReminderTime to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
      'isEnabled': isEnabled,
    };
  }

  /// Create a ReminderTime from a map (JSON deserialization)
  factory ReminderTime.fromJson(Map<String, dynamic> json) {
    return ReminderTime(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      isEnabled: json['isEnabled'] as bool,
    );
  }
}

/// Model for representing notification settings
class NotificationSettings {
  /// Whether notifications are enabled globally
  final bool isEnabled;

  /// List of reminder times
  final List<ReminderTime> reminderTimes;

  /// Whether smart reminders are enabled
  final bool smartRemindersEnabled;

  /// Start of quiet hours (no notifications during this period)
  final ReminderTime quietHoursStart;

  /// End of quiet hours
  final ReminderTime quietHoursEnd;

  /// Constructor for creating notification settings
  NotificationSettings({
    this.isEnabled = true,
    List<ReminderTime>? reminderTimes,
    this.smartRemindersEnabled = true,
    ReminderTime? quietHoursStart,
    ReminderTime? quietHoursEnd,
  })  : reminderTimes = reminderTimes ?? [],
        quietHoursStart = quietHoursStart ?? ReminderTime(hour: 22, minute: 0),
        quietHoursEnd = quietHoursEnd ?? ReminderTime(hour: 7, minute: 0);

  /// Default constructor with recommended reminder times
  factory NotificationSettings.defaultSettings() {
    return NotificationSettings(
      isEnabled: true,
      reminderTimes: [
        ReminderTime(hour: 8, minute: 0), // Morning
        ReminderTime(hour: 11, minute: 0), // Mid-morning
        ReminderTime(hour: 13, minute: 0), // Lunch
        ReminderTime(hour: 15, minute: 0), // Afternoon
        ReminderTime(hour: 18, minute: 0), // Evening
        ReminderTime(hour: 20, minute: 0), // Night
      ],
      smartRemindersEnabled: true,
      quietHoursStart: ReminderTime(hour: 22, minute: 0),
      quietHoursEnd: ReminderTime(hour: 7, minute: 0),
    );
  }

  /// Generate a schedule of reminder times based on settings
  List<DateTime> generateReminderSchedule(DateTime date) {
    final List<DateTime> schedule = [];

    for (final reminderTime in reminderTimes) {
      if (reminderTime.isEnabled) {
        final reminderDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          reminderTime.hour,
          reminderTime.minute,
        );

        // Only add future reminders
        if (reminderDateTime.isAfter(DateTime.now())) {
          schedule.add(reminderDateTime);
        }
      }
    }

    return schedule;
  }

  /// Check if a given time is within quiet hours
  bool isQuietHours(DateTime time) {
    // Create reference times for today
    final today = DateTime(time.year, time.month, time.day);
    final start = today.add(
        Duration(hours: quietHoursStart.hour, minutes: quietHoursStart.minute));
    final end = today.add(
        Duration(hours: quietHoursEnd.hour, minutes: quietHoursEnd.minute));

    // Handle overnight quiet hours (e.g., 22:00 to 07:00)
    if (quietHoursStart.hour > quietHoursEnd.hour) {
      // If time is after start OR before end, it's quiet hours
      return time.isAfter(start) || time.isBefore(end);
    } else {
      // If time is after start AND before end, it's quiet hours
      return time.isAfter(start) && time.isBefore(end);
    }
  }

  /// Create a copy of this NotificationSettings with specified fields replaced with new values
  NotificationSettings copyWith({
    bool? isEnabled,
    List<ReminderTime>? reminderTimes,
    bool? smartRemindersEnabled,
    ReminderTime? quietHoursStart,
    ReminderTime? quietHoursEnd,
  }) {
    return NotificationSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      smartRemindersEnabled:
          smartRemindersEnabled ?? this.smartRemindersEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  /// Convert NotificationSettings to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'reminderTimes': reminderTimes.map((time) => time.toJson()).toList(),
      'smartRemindersEnabled': smartRemindersEnabled,
      'quietHoursStart': quietHoursStart.toJson(),
      'quietHoursEnd': quietHoursEnd.toJson(),
    };
  }

  /// Create a NotificationSettings from a map (JSON deserialization)
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      isEnabled: json['isEnabled'] as bool,
      reminderTimes: (json['reminderTimes'] as List)
          .map((e) => ReminderTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      smartRemindersEnabled: json['smartRemindersEnabled'] as bool,
      quietHoursStart: ReminderTime.fromJson(
          json['quietHoursStart'] as Map<String, dynamic>),
      quietHoursEnd:
          ReminderTime.fromJson(json['quietHoursEnd'] as Map<String, dynamic>),
    );
  }
}
