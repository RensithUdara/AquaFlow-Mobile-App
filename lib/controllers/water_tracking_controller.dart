import 'package:flutter/foundation.dart';

import '../models/daily_goal.dart';
import '../models/water_entry.dart';
import '../services/storage_service.dart';
import '../utils/utility_service.dart';

/// Controller for managing water tracking functionality
class WaterTrackingController with ChangeNotifier {
  final StorageService _storageService;

  /// Current day's water entries
  List<WaterEntry> _entries = [];

  /// Current day's goal
  DailyGoal? _dailyGoal;

  /// Current selected date
  DateTime _selectedDate = DateTime.now();

  /// Constructor for water tracking controller
  WaterTrackingController(this._storageService) {
    _loadData();
  }

  /// Get current water entries
  List<WaterEntry> get entries => List.unmodifiable(_entries);

  /// Get current daily goal
  DailyGoal? get dailyGoal => _dailyGoal;

  /// Get selected date
  DateTime get selectedDate => _selectedDate;

  /// Get total amount of water consumed for the selected date
  int get totalAmount {
    return _entries.fold(0, (sum, entry) => sum + entry.amount);
  }

  /// Get progress percentage towards daily goal
  double get progressPercentage {
    if (_dailyGoal == null || _dailyGoal!.targetAmount <= 0) return 0.0;
    return (totalAmount / _dailyGoal!.targetAmount).clamp(0.0, 1.0);
  }

  /// Get remaining amount to reach daily goal
  int get remainingAmount {
    if (_dailyGoal == null) return 0;
    final remaining = _dailyGoal!.targetAmount - totalAmount;
    return remaining > 0 ? remaining : 0;
  }

  /// Check if daily goal is completed
  bool get isGoalCompleted {
    return _dailyGoal != null && totalAmount >= _dailyGoal!.targetAmount;
  }

  /// Change the selected date
  void changeSelectedDate(DateTime date) {
    if (UtilityService.isSameDay(_selectedDate, date)) return;

    _selectedDate = date;
    _loadData();
    notifyListeners();
  }

  /// Set daily goal for the selected date
  Future<void> setDailyGoal(int targetAmount) async {
    _dailyGoal = DailyGoal(
      targetAmount: targetAmount,
      currentAmount: totalAmount,
      date: _selectedDate,
      isCompleted: totalAmount >= targetAmount,
    );

    await _storageService.saveDailyGoal(_dailyGoal!);
    notifyListeners();
  }

  /// Add a new water entry
  Future<void> addWaterEntry(int amount,
      {String drinkType = 'water', DateTime? timestamp}) async {
    final entry = WaterEntry(
      amount: amount,
      timestamp: timestamp ?? DateTime.now(),
      drinkType: drinkType,
    );

    _entries.add(entry);

    // Update daily goal if it exists
    if (_dailyGoal != null) {
      _dailyGoal = _dailyGoal!.addWater(entry);
      await _storageService.saveDailyGoal(_dailyGoal!);
    }

    await _storageService.saveWaterEntries(_selectedDate, _entries);
    notifyListeners();
  }

  /// Update an existing water entry
  Future<void> updateWaterEntry(String id,
      {int? amount, DateTime? timestamp, String? drinkType}) async {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index == -1) return;

    final oldAmount = _entries[index].amount;

    final updatedEntry = _entries[index].copyWith(
      amount: amount,
      timestamp: timestamp,
      drinkType: drinkType,
    );

    _entries[index] = updatedEntry;

    // Update daily goal if it exists and amount changed
    if (_dailyGoal != null && amount != null && amount != oldAmount) {
      final difference = amount - oldAmount;
      if (difference > 0) {
        final entry = WaterEntry(
          amount: difference,
          timestamp: updatedEntry.timestamp,
          drinkType: updatedEntry.drinkType,
        );
        _dailyGoal = _dailyGoal!.addWater(entry);
      } else {
        final entry = WaterEntry(
          amount: difference.abs(),
          timestamp: updatedEntry.timestamp,
          drinkType: updatedEntry.drinkType,
        );
        _dailyGoal = _dailyGoal!.removeWater(entry);
      }
      await _storageService.saveDailyGoal(_dailyGoal!);
    }

    await _storageService.saveWaterEntries(_selectedDate, _entries);
    notifyListeners();
  }

  /// Remove a water entry
  Future<void> removeWaterEntry(String id) async {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index == -1) return;

    final removedEntry = _entries[index];

    _entries.removeAt(index);

    // Update daily goal if it exists
    if (_dailyGoal != null) {
      _dailyGoal = _dailyGoal!.removeWater(removedEntry);
      await _storageService.saveDailyGoal(_dailyGoal!);
    }

    await _storageService.saveWaterEntries(_selectedDate, _entries);
    notifyListeners();
  }

  /// Get the last entry added
  WaterEntry? getLastEntry() {
    if (_entries.isEmpty) return null;
    return _entries.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
  }

  /// Load data from storage for the selected date
  Future<void> _loadData() async {
    _entries = _storageService.getWaterEntries(_selectedDate);
    _dailyGoal = _storageService.getDailyGoal(_selectedDate);
  }
}
