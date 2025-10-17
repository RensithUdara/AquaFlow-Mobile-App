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
    DateTime? date,
    bool? isCompleted,
  }) {
    return DailyGoal(
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Add a water entry amount to the current amount
  DailyGoal addWater(int amount) {
    final newAmount = currentAmount + amount;
    return copyWith(
      currentAmount: newAmount,
      isCompleted: newAmount >= targetAmount,
    );
  }

  /// Remove a water entry amount from the current amount
  DailyGoal removeWater(int amount) {
    final newAmount =
        (currentAmount - amount).clamp(0, double.infinity).toInt();
    return copyWith(
      currentAmount: newAmount,
      isCompleted: newAmount >= targetAmount,
    );
  }

  /// Convert DailyGoal to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Create a DailyGoal from a map (JSON deserialization)
  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      targetAmount: json['targetAmount'] as int,
      currentAmount: json['currentAmount'] as int,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
