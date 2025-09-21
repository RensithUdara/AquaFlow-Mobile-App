import 'package:flutter/foundation.dart';
import '../models/water_entry.dart';
import '../models/daily_goal.dart';
import '../services/storage_service.dart';
import '../utils/utility_service.dart';

/// Controller for managing water intake history
class HistoryController with ChangeNotifier {
  final StorageService _storageService;
  
  /// Currently viewed date range
  DateRange _currentRange = DateRange.week;
  
  /// Reference date for the current range (usually today)
  DateTime _referenceDate = DateTime.now();
  
  /// Map of dates to water entries
  Map<DateTime, List<WaterEntry>> _entriesByDate = {};
  
  /// Map of dates to daily goals
  Map<DateTime, DailyGoal?> _goalsByDate = {};

  /// Constructor for history controller
  HistoryController(this._storageService) {
    _loadHistory();
  }

  /// Get current date range type
  DateRange get currentRange => _currentRange;
  
  /// Get reference date
  DateTime get referenceDate => _referenceDate;
  
  /// Get all entries by date
  Map<DateTime, List<WaterEntry>> get entriesByDate => Map.unmodifiable(_entriesByDate);
  
  /// Get all goals by date
  Map<DateTime, DailyGoal?> get goalsByDate => Map.unmodifiable(_goalsByDate);

  /// Get dates in the current range
  List<DateTime> get datesInRange {
    switch (_currentRange) {
      case DateRange.day:
        return [_referenceDate];
      case DateRange.week:
        return UtilityService.datesOfWeek(_referenceDate);
      case DateRange.month:
        return UtilityService.datesOfMonth(_referenceDate);
      case DateRange.year:
        return List.generate(12, (index) => 
          DateTime(_referenceDate.year, index + 1, 1)
        );
    }
  }

  /// Get total amount for a specific date
  int getAmountForDate(DateTime date) {
    final dateKey = UtilityService.startOfDay(date);
    final entries = _entriesByDate[dateKey] ?? [];
    return entries.fold(0, (sum, entry) => sum + entry.amount);
  }

  /// Get progress percentage for a specific date
  double getProgressForDate(DateTime date) {
    final dateKey = UtilityService.startOfDay(date);
    final goal = _goalsByDate[dateKey];
    if (goal == null || goal.targetAmount <= 0) return 0.0;
    
    final amount = getAmountForDate(date);
    return (amount / goal.targetAmount).clamp(0.0, 1.0);
  }

  /// Check if goal was completed for a specific date
  bool isGoalCompletedForDate(DateTime date) {
    final dateKey = UtilityService.startOfDay(date);
    final goal = _goalsByDate[dateKey];
    if (goal == null) return false;
    
    final amount = getAmountForDate(date);
    return amount >= goal.targetAmount;
  }

  /// Get statistics for the current range
  HistoryStatistics getStatistics() {
    final dates = datesInRange;
    
    // Calculate total intake
    int totalIntake = 0;
    int daysTracked = 0;
    int daysCompleted = 0;
    int highestAmount = 0;
    DateTime? bestDay;
    
    for (final date in dates) {
      final dateKey = UtilityService.startOfDay(date);
      final amount = getAmountForDate(date);
      
      if (amount > 0) {
        totalIntake += amount;
        daysTracked++;
      }
      
      if (isGoalCompletedForDate(date)) {
        daysCompleted++;
      }
      
      if (amount > highestAmount) {
        highestAmount = amount;
        bestDay = date;
      }
    }
    
    // Calculate average intake for tracked days
    final averageIntake = daysTracked > 0 ? (totalIntake / daysTracked).round() : 0;
    
    // Calculate completion rate
    final completionRate = daysTracked > 0 ? (daysCompleted / daysTracked) : 0.0;
    
    return HistoryStatistics(
      totalIntake: totalIntake,
      averageIntake: averageIntake,
      daysTracked: daysTracked,
      daysCompleted: daysCompleted,
      completionRate: completionRate,
      highestAmount: highestAmount,
      bestDay: bestDay,
    );
  }

  /// Change the current date range
  void changeRange(DateRange range, {DateTime? referenceDate}) {
    _currentRange = range;
    if (referenceDate != null) {
      _referenceDate = referenceDate;
    }
    
    _loadHistory();
    notifyListeners();
  }

  /// Go to previous range (e.g., previous week, month)
  void goToPrevious() {
    switch (_currentRange) {
      case DateRange.day:
        _referenceDate = _referenceDate.subtract(const Duration(days: 1));
        break;
      case DateRange.week:
        _referenceDate = _referenceDate.subtract(const Duration(days: 7));
        break;
      case DateRange.month:
        _referenceDate = DateTime(
          _referenceDate.year,
          _referenceDate.month - 1,
          1,
        );
        break;
      case DateRange.year:
        _referenceDate = DateTime(
          _referenceDate.year - 1,
          1,
          1,
        );
        break;
    }
    
    _loadHistory();
    notifyListeners();
  }

  /// Go to next range (e.g., next week, month)
  void goToNext() {
    switch (_currentRange) {
      case DateRange.day:
        _referenceDate = _referenceDate.add(const Duration(days: 1));
        break;
      case DateRange.week:
        _referenceDate = _referenceDate.add(const Duration(days: 7));
        break;
      case DateRange.month:
        _referenceDate = DateTime(
          _referenceDate.year,
          _referenceDate.month + 1,
          1,
        );
        break;
      case DateRange.year:
        _referenceDate = DateTime(
          _referenceDate.year + 1,
          1,
          1,
        );
        break;
    }
    
    _loadHistory();
    notifyListeners();
  }

  /// Reset to current date
  void resetToToday() {
    _referenceDate = DateTime.now();
    _loadHistory();
    notifyListeners();
  }

  /// Load history data for the current range
  Future<void> _loadHistory() async {
    _entriesByDate = {};
    _goalsByDate = {};
    
    final dates = datesInRange;
    
    for (final date in dates) {
      final dateKey = UtilityService.startOfDay(date);
      
      final entries = _storageService.getWaterEntries(date);
      final goal = _storageService.getDailyGoal(date);
      
      _entriesByDate[dateKey] = entries;
      _goalsByDate[dateKey] = goal;
    }
  }
}

/// Enum for date range options
enum DateRange {
  day,
  week,
  month,
  year,
}

/// Class for history statistics
class HistoryStatistics {
  /// Total water intake in milliliters
  final int totalIntake;
  
  /// Average daily intake in milliliters
  final int averageIntake;
  
  /// Number of days with tracked data
  final int daysTracked;
  
  /// Number of days with completed goals
  final int daysCompleted;
  
  /// Rate of goal completion (0.0 - 1.0)
  final double completionRate;
  
  /// Highest daily amount in milliliters
  final int highestAmount;
  
  /// Best day (day with highest amount)
  final DateTime? bestDay;

  /// Constructor for history statistics
  HistoryStatistics({
    required this.totalIntake,
    required this.averageIntake,
    required this.daysTracked,
    required this.daysCompleted,
    required this.completionRate,
    required this.highestAmount,
    this.bestDay,
  });
}