/// Enum to represent goal period types
enum GoalPeriod {
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case GoalPeriod.weekly:
        return 'Weekly';
      case GoalPeriod.monthly:
        return 'Monthly';
    }
  }
}

/// Model for representing weekly or monthly water intake goals
class PeriodGoal {
  /// The period type (weekly or monthly)
  final GoalPeriod period;

  /// Start date of the period
  final DateTime startDate;

  /// Target amount for the period in milliliters
  final int targetAmount;

  /// Current amount consumed in the period
  final int currentAmount;

  /// Whether this goal has been completed
  final bool isCompleted;

  /// Number of days in the period where daily goal was met
  final int daysCompleted;

  /// Constructor for creating a period goal
  PeriodGoal({
    required this.period,
    required this.startDate,
    required this.targetAmount,
    this.currentAmount = 0,
    this.isCompleted = false,
    this.daysCompleted = 0,
  });

  /// Calculate the end date based on period type
  DateTime get endDate {
    switch (period) {
      case GoalPeriod.weekly:
        return startDate.add(const Duration(days: 7));
      case GoalPeriod.monthly:
        // Add one month by incrementing the month value
        return DateTime(
          startDate.year,
          startDate.month + 1,
          startDate.day,
        ).subtract(const Duration(days: 1));
    }
  }

  /// Get progress percentage towards the period goal
  double get progressPercentage =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  /// Get remaining amount to reach the goal
  int get remainingAmount =>
      currentAmount >= targetAmount ? 0 : targetAmount - currentAmount;

  /// Get total days in the period
  int get totalDays {
    return endDate.difference(startDate).inDays + 1;
  }

  /// Get percentage of days completed
  double get daysCompletionRate => daysCompleted / totalDays;

  /// Create a copy of this PeriodGoal with specified fields replaced with new values
  PeriodGoal copyWith({
    GoalPeriod? period,
    DateTime? startDate,
    int? targetAmount,
    int? currentAmount,
    bool? isCompleted,
    int? daysCompleted,
  }) {
    return PeriodGoal(
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      isCompleted: isCompleted ?? this.isCompleted,
      daysCompleted: daysCompleted ?? this.daysCompleted,
    );
  }

  /// Add water amount to the current amount
  PeriodGoal addWater(int amount) {
    final newAmount = currentAmount + amount;
    return copyWith(
      currentAmount: newAmount,
      isCompleted: newAmount >= targetAmount,
    );
  }

  /// Remove water amount from the current amount
  PeriodGoal removeWater(int amount) {
    final newAmount =
        (currentAmount - amount).clamp(0, double.infinity).toInt();
    return copyWith(
      currentAmount: newAmount,
      isCompleted: newAmount >= targetAmount,
    );
  }

  /// Mark a day as completed
  PeriodGoal addCompletedDay() {
    final newDaysCompleted = daysCompleted + 1;
    return copyWith(
      daysCompleted: newDaysCompleted,
    );
  }

  /// Convert PeriodGoal to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'period': period.index,
      'startDate': startDate.toIso8601String(),
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'isCompleted': isCompleted,
      'daysCompleted': daysCompleted,
    };
  }

  /// Create a PeriodGoal from a map (JSON deserialization)
  factory PeriodGoal.fromJson(Map<String, dynamic> json) {
    return PeriodGoal(
      period: GoalPeriod.values[json['period'] as int],
      startDate: DateTime.parse(json['startDate'] as String),
      targetAmount: json['targetAmount'] as int,
      currentAmount: json['currentAmount'] as int,
      isCompleted: json['isCompleted'] as bool,
      daysCompleted: json['daysCompleted'] as int,
    );
  }
}
