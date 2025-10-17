import 'water_entry.dart';

/// Model for representing a user's daily water intake goal
class DailyGoal {
  /// Target amount of water in milliliters for the day
  final int targetAmount;

  /// Current amount of water consumed in milliliters (actual hydration amount)
  final int currentAmount;

  /// Total amount of drinks consumed in milliliters (raw amount)
  final int totalAmount;

  /// Date for this goal
  final DateTime date;

  /// Whether the goal has been completed
  final bool isCompleted;

  /// Whether this goal maintains a streak from previous days
  final bool maintainsStreak;

  /// Constructor for creating a daily goal
  DailyGoal({
    required this.targetAmount,
    this.currentAmount = 0,
    this.totalAmount = 0,
    required this.date,
    this.isCompleted = false,
    this.maintainsStreak = false,
  });

  /// Get the percentage of progress towards the daily goal
  double get progressPercentage =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  /// Get the remaining amount of water to reach the goal
  int get remainingAmount =>
      currentAmount >= targetAmount ? 0 : targetAmount - currentAmount;

  /// Create a copy of this DailyGoal with specified fields replaced with new values
  DailyGoal copyWith({
    int? targetAmount,
    int? currentAmount,
    int? totalAmount,
    DateTime? date,
    bool? isCompleted,
    bool? maintainsStreak,
  }) {
    return DailyGoal(
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      maintainsStreak: maintainsStreak ?? this.maintainsStreak,
    );
  }

  /// Add a water entry to the goal
  DailyGoal addWater(WaterEntry entry) {
    final newTotal = totalAmount + entry.amount;
    final newHydration = currentAmount + entry.hydrationAmount;
    return copyWith(
      totalAmount: newTotal,
      currentAmount: newHydration,
      isCompleted: newHydration >= targetAmount,
    );
  }

  /// Remove a water entry from the goal
  DailyGoal removeWater(WaterEntry entry) {
    final newTotal =
        (totalAmount - entry.amount).clamp(0, double.infinity).toInt();
    final newHydration = (currentAmount - entry.hydrationAmount)
        .clamp(0, double.infinity)
        .toInt();
    return copyWith(
      totalAmount: newTotal,
      currentAmount: newHydration,
      isCompleted: newHydration >= targetAmount,
    );
  }

  /// Convert DailyGoal to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'maintainsStreak': maintainsStreak,
    };
  }

  /// Create a DailyGoal from a map (JSON deserialization)
  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      targetAmount: json['targetAmount'] as int,
      currentAmount: json['currentAmount'] as int,
      totalAmount: json['totalAmount'] as int? ?? json['currentAmount'] as int,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool,
      maintainsStreak: json['maintainsStreak'] as bool? ?? false,
    );
  }
}
