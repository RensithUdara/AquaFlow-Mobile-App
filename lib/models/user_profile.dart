/// Enum to represent user activity levels
enum ActivityLevel {
  sedentary(baseFactor: 1.0, extraHeatFactor: 0.1),
  lightlyActive(baseFactor: 1.2, extraHeatFactor: 0.15),
  moderatelyActive(baseFactor: 1.4, extraHeatFactor: 0.2),
  veryActive(baseFactor: 1.6, extraHeatFactor: 0.25),
  extraActive(baseFactor: 1.8, extraHeatFactor: 0.3);

  const ActivityLevel({
    required this.baseFactor,
    required this.extraHeatFactor,
  });

  final double baseFactor;
  final double extraHeatFactor;

  /// Get activity level factor for hydration calculation considering temperature
  double getHydrationFactor(double temperatureCelsius) {
    // Base hydration factor
    double factor = baseFactor;

    // Add extra hydration need for high temperatures (above 25°C)
    if (temperatureCelsius > 25) {
      // Calculate additional factor based on how much above 25°C
      double tempDiff = temperatureCelsius - 25;
      factor += (extraHeatFactor *
          tempDiff /
          10); // Gradual increase with temperature
    }

    return factor;
  }
}

/// Model for representing user profile information
class UserProfile {
  /// Constructor for UserProfile
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.dailyGoal,
    required this.weight,
    required this.activityLevel,
    required this.notificationsEnabled,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalGoalsAchieved = 0,
  });

  /// Unique identifier for the user
  final String id;

  /// User's display name
  final String displayName;

  /// User's daily water intake goal in milliliters
  final int dailyGoal;

  /// User's weight in kilograms
  final double weight;

  /// User's activity level
  final ActivityLevel activityLevel;

  /// Whether notifications are enabled
  final bool notificationsEnabled;

  /// Current streak of meeting daily goals
  final int currentStreak;

  /// Longest streak achieved
  final int longestStreak;

  /// Total number of daily goals achieved (total successful days)
  final int totalGoalsAchieved;
    required this.id,
    required this.displayName,
    required this.dailyGoal,
    required this.weight,
    required this.activityLevel,
    this.notificationsEnabled = true,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalGoalsAchieved = 0,
  });

  /// Default constructor with recommended values
  factory UserProfile.defaultProfile() {
    return UserProfile(
      id: 'default',
      displayName: 'New User',
      dailyGoal: 2500, // Default 2.5L
      weight: 70.0, // Default 70kg
      activityLevel: ActivityLevel.moderatelyActive,
      notificationsEnabled: true,
    );
  }

  /// Calculate recommended water intake based on weight, activity level, and temperature
  int calculateRecommendedIntake({double temperatureCelsius = 25.0}) {
    // Base calculation: 35ml per kg of body weight
    double baseIntake = weight * 35;

    // Adjust for activity level and temperature
    baseIntake *= activityLevel.getHydrationFactor(temperatureCelsius);
      baseIntake *= temperatureFactor;
    }

    return baseIntake.round();
  }

  /// Create a copy of this UserProfile with specified fields replaced with new values
  UserProfile copyWith({
    String? id,
    String? displayName,
    int? dailyGoal,
    double? weight,
    ActivityLevel? activityLevel,
    bool? notificationsEnabled,
    int? currentStreak,
    int? longestStreak,
    int? totalGoalsAchieved,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalGoalsAchieved: totalGoalsAchieved ?? this.totalGoalsAchieved,
    );
  }

  /// Convert UserProfile to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'dailyGoal': dailyGoal,
      'weight': weight,
      'activityLevel': activityLevel.index,
      'notificationsEnabled': notificationsEnabled,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalGoalsAchieved': totalGoalsAchieved,
    };
  }

  /// Create a UserProfile from a map (JSON deserialization)
  UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      dailyGoal: json['dailyGoal'] as int,
      weight: (json['weight'] as num).toDouble(),
      activityLevel: ActivityLevel.values[json['activityLevel'] as int],
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      totalGoalsAchieved: json['totalGoalsAchieved'] as int? ?? 0,
    );
  }
}
