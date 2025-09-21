/// Enum to represent user activity levels
enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive
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

  /// Constructor for creating a user profile
  UserProfile({
    required this.dailyGoal,
    required this.weight,
    required this.activityLevel,
    this.notificationsEnabled = true,
  });

  /// Default constructor with recommended values
  factory UserProfile.defaultProfile() {
    return UserProfile(
      dailyGoal: 2500, // Default 2.5L
      weight: 70.0,    // Default 70kg
      activityLevel: ActivityLevel.moderatelyActive,
      notificationsEnabled: true,
    );
  }

  /// Calculate recommended water intake based on weight and activity level
  int calculateRecommendedIntake() {
    // Base calculation: 30ml per kg of body weight
    double baseAmount = weight * 30;
    
    // Adjust for activity level
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        baseAmount *= 1.0;
      case ActivityLevel.lightlyActive:
        baseAmount *= 1.1;
      case ActivityLevel.moderatelyActive:
        baseAmount *= 1.2;
      case ActivityLevel.veryActive:
        baseAmount *= 1.3;
      case ActivityLevel.extraActive:
        baseAmount *= 1.4;
    }
    
    return baseAmount.round();
  }

  /// Create a copy of this UserProfile with specified fields replaced with new values
  UserProfile copyWith({
    int? dailyGoal,
    double? weight,
    ActivityLevel? activityLevel,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  /// Convert UserProfile to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'dailyGoal': dailyGoal,
      'weight': weight,
      'activityLevel': activityLevel.index,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  /// Create a UserProfile from a map (JSON deserialization)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      dailyGoal: json['dailyGoal'] as int,
      weight: (json['weight'] as num).toDouble(),
      activityLevel: ActivityLevel.values[json['activityLevel'] as int],
      notificationsEnabled: json['notificationsEnabled'] as bool,
    );
  }
}