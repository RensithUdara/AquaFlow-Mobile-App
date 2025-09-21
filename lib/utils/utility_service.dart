import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_constants.dart';

/// Utility service with helper methods
class UtilityService {
  /// Format a date as a string
  static String formatDate(DateTime date, {String format = 'MMM d, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format a time as a string
  static String formatTime(DateTime time, {String format = 'h:mm a'}) {
    return DateFormat(format).format(time);
  }

  /// Format an amount with the appropriate unit
  static String formatAmount(int amount, {bool useMetric = true}) {
    if (useMetric) {
      if (amount < 1000) {
        return '$amount ${AppConstants.mlUnit}';
      } else {
        return '${(amount / 1000).toStringAsFixed(1)} L';
      }
    } else {
      // Convert to fluid ounces
      final double oz = amount * AppConstants.mlToOzFactor;
      return '${oz.toStringAsFixed(1)} ${AppConstants.ozUnit}';
    }
  }

  /// Convert milliliters to fluid ounces
  static double mlToOz(int ml) {
    return ml * AppConstants.mlToOzFactor;
  }

  /// Convert fluid ounces to milliliters
  static int ozToMl(double oz) {
    return (oz * AppConstants.ozToMlFactor).round();
  }

  /// Get color for progress indicator based on progress percentage
  static Color getProgressColor(double progressPercentage, bool isDarkMode) {
    if (progressPercentage >= 1.0) {
      return isDarkMode ? Colors.green.shade400 : Colors.green;
    } else if (progressPercentage >= 0.7) {
      return isDarkMode ? Colors.blue.shade300 : Colors.blue;
    } else if (progressPercentage >= 0.4) {
      return isDarkMode ? Colors.amber.shade300 : Colors.amber;
    } else {
      return isDarkMode ? Colors.red.shade300 : Colors.red;
    }
  }

  /// Get a motivational message based on current progress
  static String getMotivationalMessage(double progressPercentage) {
    if (progressPercentage >= 1.0) {
      return 'Great job! You\'ve reached your daily goal! 🎉';
    } else if (progressPercentage >= 0.7) {
      return 'Almost there! Keep going! 💪';
    } else if (progressPercentage >= 0.4) {
      return 'You\'re making good progress! 👍';
    } else if (progressPercentage >= 0.2) {
      return 'Let\'s keep those water levels rising! 💧';
    } else {
      return 'Time to start hydrating! 💦';
    }
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get the start of the day for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of the day for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get the start of the week for a given date (week starts on Monday)
  static DateTime startOfWeek(DateTime date) {
    final int daysToSubtract = (date.weekday - 1) % 7;
    return startOfDay(date.subtract(Duration(days: daysToSubtract)));
  }

  /// Get the end of the week for a given date (week ends on Sunday)
  static DateTime endOfWeek(DateTime date) {
    final int daysToAdd = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToAdd)));
  }

  /// Get the start of the month for a given date
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of the month for a given date
  static DateTime endOfMonth(DateTime date) {
    return endOfDay(DateTime(date.year, date.month + 1, 0));
  }

  /// Get a list of dates for the current week
  static List<DateTime> datesOfWeek(DateTime date) {
    final start = startOfWeek(date);
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  /// Get a list of dates for the current month
  static List<DateTime> datesOfMonth(DateTime date) {
    final start = startOfMonth(date);
    final end = endOfMonth(date);
    final daysInMonth = end.day;
    return List.generate(
        daysInMonth, (index) => DateTime(start.year, start.month, index + 1));
  }

  /// Show a snackbar message
  static void showSnackbar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.blue,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: isError ? 3 : 2),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
