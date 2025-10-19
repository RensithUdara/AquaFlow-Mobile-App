import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/daily_goal.dart';
import '../models/hydration_insight.dart';
import '../models/water_analytics.dart';
import '../models/water_entry.dart';
import '../services/storage_service.dart';

/// Service for analyzing water consumption data and generating insights
class AnalyticsService {
  final StorageService _storageService;

  /// Constructor for analytics service
  AnalyticsService(this._storageService);

  /// Generate analytics for a given time period
  Future<WaterAnalytics> generateAnalytics(DateTime start, DateTime end) async {
    final entries = await _storageService.getWaterEntriesForPeriod(start, end);
    final dailyGoals = await _storageService.getDailyGoalsForPeriod(start, end);

    // Calculate basic statistics
    final totalConsumption =
        entries.fold(0, (sum, entry) => sum + entry.hydrationAmount);
    final daysTracked = _countDaysWithEntries(entries);
    final averageDailyConsumption =
        daysTracked > 0 ? totalConsumption / daysTracked : 0.0;

    // Calculate peak hydration hour
    final peakHour = _calculatePeakHydrationHour(entries);

    // Calculate goal completion rate
    final completedGoals = dailyGoals.where((goal) => goal.isCompleted).length;
    final goalCompletionRate =
        dailyGoals.isNotEmpty ? completedGoals / dailyGoals.length : 0.0;

    // Calculate consumption variance
    final consumptionVariance =
        _calculateConsumptionVariance(entries, averageDailyConsumption.round());

    // Find max streak and most common drink type
    final maxStreak = _calculateMaxStreak(dailyGoals);
    final mostCommonDrinkType = _findMostCommonDrinkType(entries);

    return WaterAnalytics(
      startDate: start,
      endDate: end,
      averageDailyConsumption: averageDailyConsumption,
      peakHydrationHour: peakHour,
      goalCompletionRate: goalCompletionRate,
      consumptionVariance: consumptionVariance,
      maxStreak: maxStreak,
      daysTracked: daysTracked,
      mostCommonDrinkType: mostCommonDrinkType,
      totalConsumption: totalConsumption,
    );
  }

  /// Generate insights based on analytics and historical data
  Future<List<HydrationInsight>> generateInsights() async {
    final insights = <HydrationInsight>[];
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));

    // Get recent analytics
    final analytics = await generateAnalytics(lastWeek, now);
    final userProfile = _storageService.getUserProfile();

    // Analyze consistency
    if (analytics.consumptionVariance > 0.5) {
      insights.add(HydrationInsight(
        id: 'consistency_${DateTime.now().millisecondsSinceEpoch}',
        type: InsightType.recommendation,
        category: InsightCategory.pattern,
        title: 'Improve Your Consistency',
        description:
            'Your daily water intake varies significantly. Try to maintain a more consistent drinking schedule.',
        generatedAt: now,
        priority: 3,
        icon: Icons.accessibility_new,
      ));
    }

    // Peak hydration time insight
    insights.add(HydrationInsight(
      id: 'peak_time_${DateTime.now().millisecondsSinceEpoch}',
      type: InsightType.pattern,
      category: InsightCategory.schedule,
      title: 'Peak Hydration Time',
      description:
          'You drink most of your water around ${analytics.peakHydrationHour}:00. This is a great habit to maintain!',
      generatedAt: now,
      priority: 2,
      icon: Icons.schedule,
    ));

    // Goal achievement trend
    if (analytics.goalCompletionRate < 0.7) {
      insights.add(HydrationInsight(
        id: 'goal_trend_${DateTime.now().millisecondsSinceEpoch}',
        type: InsightType.trend,
        category: InsightCategory.consumption,
        title: 'Room for Improvement',
        description:
            'You\'ve achieved your daily goal ${(analytics.goalCompletionRate * 100).round()}% of the time this week. Small, consistent increases can help you reach your goals.',
        generatedAt: now,
        priority: 4,
        icon: Icons.trending_up,
      ));
    }

    // Health impact metrics
    insights.add(HydrationInsight(
      id: 'health_impact_${DateTime.now().millisecondsSinceEpoch}',
      type: InsightType.healthImpact,
      category: InsightCategory.health,
      title: 'Health Benefits',
      description:
          'By maintaining good hydration, you\'re supporting better digestion, skin health, and cognitive function.',
      generatedAt: now,
      priority: 3,
      icon: Icons.favorite,
    ));

    // Add streak-related insights
    if (userProfile.currentStreak > 0) {
      insights.add(HydrationInsight(
        id: 'streak_${DateTime.now().millisecondsSinceEpoch}',
        type: InsightType.achievement,
        category: InsightCategory.streak,
        title: 'Keep the Streak Going!',
        description:
            'You\'re on a ${userProfile.currentStreak}-day streak. Keep it up!',
        generatedAt: now,
        priority: 5,
        icon: Icons.local_fire_department,
      ));
    }

    return insights;
  }

  /// Count number of unique days that have entries
  int _countDaysWithEntries(List<WaterEntry> entries) {
    final uniqueDays = <DateTime>{};
    for (final entry in entries) {
      final date = DateTime(
        entry.timestamp.year,
        entry.timestamp.month,
        entry.timestamp.day,
      );
      uniqueDays.add(date);
    }
    return uniqueDays.length;
  }

  /// Calculate the hour of day with highest water consumption
  int _calculatePeakHydrationHour(List<WaterEntry> entries) {
    final hourlyConsumption = List<int>.filled(24, 0);
    for (final entry in entries) {
      hourlyConsumption[entry.timestamp.hour] += entry.hydrationAmount;
    }
    return hourlyConsumption.indexOf(hourlyConsumption.reduce(math.max));
  }

  /// Calculate variance in daily consumption
  double _calculateConsumptionVariance(List<WaterEntry> entries, int average) {
    if (entries.isEmpty) return 0.0;

    final dailyTotals = <int>[];
    final Map<DateTime, int> dailyMap = {};

    // Group entries by day
    for (final entry in entries) {
      final date = DateTime(
        entry.timestamp.year,
        entry.timestamp.month,
        entry.timestamp.day,
      );
      dailyMap[date] = (dailyMap[date] ?? 0) + entry.hydrationAmount;
    }

    dailyTotals.addAll(dailyMap.values);

    // Calculate variance
    final squaredDiffs = dailyTotals.map((total) {
      final diff = total - average;
      return diff * diff;
    });

    return squaredDiffs.reduce((a, b) => a + b) / dailyTotals.length;
  }

  /// Calculate maximum streak from daily goals
  int _calculateMaxStreak(List<DailyGoal> goals) {
    if (goals.isEmpty) return 0;

    int maxStreak = 0;
    int currentStreak = 0;

    // Sort goals by date
    final sortedGoals = List<DailyGoal>.from(goals)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final goal in sortedGoals) {
      if (goal.isCompleted) {
        currentStreak++;
        maxStreak = math.max(maxStreak, currentStreak);
      } else {
        currentStreak = 0;
      }
    }

    return maxStreak;
  }

  /// Find the most common drink type
  String _findMostCommonDrinkType(List<WaterEntry> entries) {
    if (entries.isEmpty) return 'water';

    final drinkCounts = <String, int>{};
    for (final entry in entries) {
      drinkCounts[entry.drinkType] = (drinkCounts[entry.drinkType] ?? 0) + 1;
    }

    return drinkCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Export analytics data for external use
  Map<String, dynamic> exportAnalyticsData(WaterAnalytics analytics) {
    return {
      'period': {
        'start': analytics.startDate.toIso8601String(),
        'end': analytics.endDate.toIso8601String(),
      },
      'summary': {
        'totalConsumption': analytics.totalConsumption,
        'averageDaily': analytics.averageDailyConsumption.round(),
        'daysTracked': analytics.daysTracked,
        'goalCompletionRate': (analytics.goalCompletionRate * 100).round(),
        'maxStreak': analytics.maxStreak,
      },
      'patterns': {
        'peakHydrationHour': analytics.peakHydrationHour,
        'consumptionVariance': analytics.consumptionVariance,
        'mostCommonDrinkType': analytics.mostCommonDrinkType,
      },
    };
  }
}
