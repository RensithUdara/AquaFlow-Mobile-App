import 'package:flutter/material.dart';

/// Type of hydration insight
enum InsightType {
  trend,
  pattern,
  recommendation,
  achievement,
  healthImpact,
}

/// Category of the insight
enum InsightCategory {
  consumption,
  schedule,
  health,
  streak,
  social,
}

/// Model representing a hydration insight
class HydrationInsight {
  /// Unique identifier for the insight
  final String id;

  /// Type of insight
  final InsightType type;

  /// Category of the insight
  final InsightCategory category;

  /// Title of the insight
  final String title;

  /// Description or content of the insight
  final String description;

  /// Date when the insight was generated
  final DateTime generatedAt;

  /// Priority level of the insight (1-5, with 5 being highest)
  final int priority;

  /// Icon to display with the insight
  final IconData icon;

  /// Whether the insight has been viewed by the user
  bool isViewed;

  /// Whether the insight has been dismissed by the user
  bool isDismissed;

  /// Constructor for creating a hydration insight
  HydrationInsight({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.generatedAt,
    required this.priority,
    required this.icon,
    this.isViewed = false,
    this.isDismissed = false,
  });

  /// Convert insight to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'category': category.index,
      'title': title,
      'description': description,
      'generatedAt': generatedAt.toIso8601String(),
      'priority': priority,
      'icon': icon.codePoint,
      'isViewed': isViewed,
      'isDismissed': isDismissed,
    };
  }

  /// Create an insight from a map (JSON deserialization)
  factory HydrationInsight.fromJson(Map<String, dynamic> json) {
    return HydrationInsight(
      id: json['id'] as String,
      type: InsightType.values[json['type'] as int],
      category: InsightCategory.values[json['category'] as int],
      title: json['title'] as String,
      description: json['description'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      priority: json['priority'] as int,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      isViewed: json['isViewed'] as bool,
      isDismissed: json['isDismissed'] as bool,
    );
  }

  /// Create a copy of this insight with specified fields replaced with new values
  HydrationInsight copyWith({
    String? id,
    InsightType? type,
    InsightCategory? category,
    String? title,
    String? description,
    DateTime? generatedAt,
    int? priority,
    IconData? icon,
    bool? isViewed,
    bool? isDismissed,
  }) {
    return HydrationInsight(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      generatedAt: generatedAt ?? this.generatedAt,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
      isViewed: isViewed ?? this.isViewed,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }
}