import 'package:uuid/uuid.dart';

/// Model representing analytics data for water consumption
class WaterAnalytics {
  /// Unique identifier for the analytics data
  final String id;

  /// Start date of the analysis period
  final DateTime startDate;

  /// End date of the analysis period
  final DateTime endDate;

  /// Average daily consumption in milliliters
  final double averageDailyConsumption;

  /// Best time of day for hydration (hour 0-23)
  final int peakHydrationHour;

  /// Percentage of days goals were met
  final double goalCompletionRate;

  /// Variance in daily consumption
  final double consumptionVariance;

  /// Longest streak during the period
  final int maxStreak;

  /// Days in the period with tracked data
  final int daysTracked;

  /// Most common drink type
  final String mostCommonDrinkType;

  /// Total consumption during the period in milliliters
  final int totalConsumption;

  /// Constructor for creating analytics data
  WaterAnalytics({
    String? id,
    required this.startDate,
    required this.endDate,
    required this.averageDailyConsumption,
    required this.peakHydrationHour,
    required this.goalCompletionRate,
    required this.consumptionVariance,
    required this.maxStreak,
    required this.daysTracked,
    required this.mostCommonDrinkType,
    required this.totalConsumption,
  }) : id = id ?? const Uuid().v4();

  /// Convert analytics data to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'averageDailyConsumption': averageDailyConsumption,
      'peakHydrationHour': peakHydrationHour,
      'goalCompletionRate': goalCompletionRate,
      'consumptionVariance': consumptionVariance,
      'maxStreak': maxStreak,
      'daysTracked': daysTracked,
      'mostCommonDrinkType': mostCommonDrinkType,
      'totalConsumption': totalConsumption,
    };
  }

  /// Create analytics data from a map (JSON deserialization)
  factory WaterAnalytics.fromJson(Map<String, dynamic> json) {
    return WaterAnalytics(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      averageDailyConsumption: json['averageDailyConsumption'] as double,
      peakHydrationHour: json['peakHydrationHour'] as int,
      goalCompletionRate: json['goalCompletionRate'] as double,
      consumptionVariance: json['consumptionVariance'] as double,
      maxStreak: json['maxStreak'] as int,
      daysTracked: json['daysTracked'] as int,
      mostCommonDrinkType: json['mostCommonDrinkType'] as String,
      totalConsumption: json['totalConsumption'] as int,
    );
  }

  /// Create a copy of this analytics data with specified fields replaced with new values
  WaterAnalytics copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    double? averageDailyConsumption,
    int? peakHydrationHour,
    double? goalCompletionRate,
    double? consumptionVariance,
    int? maxStreak,
    int? daysTracked,
    String? mostCommonDrinkType,
    int? totalConsumption,
  }) {
    return WaterAnalytics(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      averageDailyConsumption:
          averageDailyConsumption ?? this.averageDailyConsumption,
      peakHydrationHour: peakHydrationHour ?? this.peakHydrationHour,
      goalCompletionRate: goalCompletionRate ?? this.goalCompletionRate,
      consumptionVariance: consumptionVariance ?? this.consumptionVariance,
      maxStreak: maxStreak ?? this.maxStreak,
      daysTracked: daysTracked ?? this.daysTracked,
      mostCommonDrinkType: mostCommonDrinkType ?? this.mostCommonDrinkType,
      totalConsumption: totalConsumption ?? this.totalConsumption,
    );
  }
}