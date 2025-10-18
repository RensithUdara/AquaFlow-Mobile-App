/// Enum to represent user activity levels
enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive;

  /// Get activity level factor for hydration calculation
  double get hydrationFactor {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.0;
      case ActivityLevel.lightlyActive:
        return 1.2;
      case ActivityLevel.moderatelyActive:
        return 1.4;
      case ActivityLevel.veryActive:
        return 1.6;
      case ActivityLevel.extraActive:
        return 1.8;
    }
  }
}

/// Model for representing user profile information
class UserProfile {
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

  /// Total days where goal was achieved
  final int totalGoalsAchieved;

  /// Constructor for creating a user profile
  UserProfile({
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
    
    // Adjust for activity level
    baseIntake *= activityLevel.hydrationFactor;
    
    // Adjust for temperature (increase intake by 10% for every 5°C above 25°C)
    if (temperatureCelsius > 25.0) {
      final temperatureFactor = 1.0 + (0.1 * ((temperatureCelsius - 25.0) / 5.0));
      baseIntake *= temperatureFactor;
    }
    
    return baseIntake.round();
  }

  /// Create a copy of this UserProfile with specified fields replaced with new values
  UserProfile copyWith({
    int? dailyGoal,
    double? weight,
    ActivityLevel? activityLevel,
    bool? notificationsEnabled,
    int? currentStreak,
    int? longestStreak,
    int? totalGoalsAchieved,
  }) {
    return UserProfile(
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
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
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
