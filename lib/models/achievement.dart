import 'package:flutter/material.dart';

/// Types of achievements available in the app
enum AchievementType {
  streak,
  total,
  consistency,
  social,
  challenge,
}

/// Model representing a user achievement
class Achievement {
  /// Unique identifier for the achievement
  final String id;

  /// Title of the achievement
  final String title;

  /// Description of what the achievement represents
  final String description;

  /// Type of achievement
  final AchievementType type;

  /// Icon representing the achievement
  final IconData icon;

  /// Color theme for the achievement
  final Color color;

  /// Progress towards unlocking (0.0 - 1.0)
  final double progress;

  /// Target value needed to unlock
  final int targetValue;

  /// Current value towards target
  final int currentValue;

  /// Whether the achievement has been unlocked
  final bool isUnlocked;

  /// Date when the achievement was unlocked
  final DateTime? unlockedAt;

  /// Constructor for creating an achievement
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    required this.color,
    required this.progress,
    required this.targetValue,
    required this.currentValue,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Convert achievement to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'icon': icon.codePoint,
      'color': color.value,
      'progress': progress,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  /// Create an achievement from a map (JSON deserialization)
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: AchievementType.values[json['type'] as int],
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] as int),
      progress: json['progress'] as double,
      targetValue: json['targetValue'] as int,
      currentValue: json['currentValue'] as int,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  /// Create a copy of this achievement with specified fields replaced with new values
  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    IconData? icon,
    Color? color,
    double? progress,
    int? targetValue,
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      progress: progress ?? this.progress,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// Predefined achievement templates
  static final List<Achievement> templates = [
    Achievement(
      id: 'streak_7',
      title: 'Weekly Warrior',
      description: 'Maintain a 7-day hydration streak',
      type: AchievementType.streak,
      icon: Icons.local_fire_department,
      color: Colors.orange,
      progress: 0.0,
      targetValue: 7,
      currentValue: 0,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Hydration Master',
      description: 'Maintain a 30-day hydration streak',
      type: AchievementType.streak,
      icon: Icons.workspace_premium,
      color: Colors.purple,
      progress: 0.0,
      targetValue: 30,
      currentValue: 0,
    ),
    Achievement(
      id: 'total_100',
      title: 'Century Club',
      description: 'Complete your daily goal 100 times',
      type: AchievementType.total,
      icon: Icons.military_tech,
      color: Colors.green,
      progress: 0.0,
      targetValue: 100,
      currentValue: 0,
    ),
    // Add more achievement templates as needed
  ];
}
