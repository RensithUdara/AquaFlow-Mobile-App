import 'dart:convert';

import '../models/health_data.dart';
import '../models/water_entry.dart';
import '../services/storage_service.dart';
import '../utils/app_constants.dart';

/// Service for exporting health data to external platforms
class HealthExportService {
  final StorageService _storageService;

  /// Constructor for health export service
  HealthExportService(this._storageService);

  /// Export water data to Apple Health format
  Future<HealthData> exportToAppleHealth(DateTime start, DateTime end) async {
    final entries = await _storageService.getWaterEntriesForPeriod(start, end);
    final waterData = _formatForAppleHealth(entries);

    return HealthData(
      startDate: start,
      endDate: end,
      format: HealthDataFormat.appleHealth,
      waterData: waterData,
      metadata: HealthData.generateMetadata(),
    );
  }

  /// Export water data to Google Fit format
  Future<HealthData> exportToGoogleFit(DateTime start, DateTime end) async {
    final entries = await _storageService.getWaterEntriesForPeriod(start, end);
    final waterData = _formatForGoogleFit(entries);

    return HealthData(
      startDate: start,
      endDate: end,
      format: HealthDataFormat.googleFit,
      waterData: waterData,
      metadata: HealthData.generateMetadata(),
    );
  }

  /// Export water data to CSV format
  Future<HealthData> exportToCSV(DateTime start, DateTime end) async {
    final entries = await _storageService.getWaterEntriesForPeriod(start, end);
    final waterData = _formatForCSV(entries);

    return HealthData(
      startDate: start,
      endDate: end,
      format: HealthDataFormat.csv,
      waterData: {'csvData': waterData},
      metadata: HealthData.generateMetadata(),
    );
  }

  /// Format water entries for Apple Health
  Map<String, dynamic> _formatForAppleHealth(List<WaterEntry> entries) {
    final samples = entries
        .map((entry) => {
              'type': 'HKQuantityTypeIdentifierDietaryWater',
              'amount': entry.amount / 1000.0, // Convert to liters
              'unit': 'L',
              'date': entry.timestamp.toIso8601String(),
              'sourceApp': AppConstants.appName,
              'sourceName': 'AquaFlow Water Tracking',
              'metadata': {
                'drinkType': entry.drinkType,
                'hydrationCoefficient': entry.hydrationAmount / entry.amount,
              }
            })
        .toList();

    return {
      'workoutData': samples,
      'exportDate': DateTime.now().toIso8601String(),
      'dataType': 'waterIntake',
    };
  }

  /// Format water entries for Google Fit
  Map<String, dynamic> _formatForGoogleFit(List<WaterEntry> entries) {
    final dataPoints = entries
        .map((entry) => {
              'dataTypeName': 'com.google.hydration',
              'startTimeNanos':
                  entry.timestamp.millisecondsSinceEpoch * 1000000,
              'endTimeNanos': entry.timestamp.millisecondsSinceEpoch * 1000000,
              'value': [
                {
                  'fpVal': entry.amount / 1000.0, // Convert to liters
                  'mapVal': [
                    {
                      'key': 'drinkType',
                      'value': {'stringVal': entry.drinkType}
                    },
                    {
                      'key': 'hydrationCoefficient',
                      'value': {'fpVal': entry.hydrationAmount / entry.amount}
                    },
                  ]
                }
              ]
            })
        .toList();

    return {
      'minStartTimeNs': start.millisecondsSinceEpoch * 1000000,
      'maxEndTimeNs': end.millisecondsSinceEpoch * 1000000,
      'dataSourceId':
          'raw:com.google.hydration:${AppConstants.appName}:android-app',
      'points': dataPoints,
    };
  }

  /// Format water entries for CSV export
  String _formatForCSV(List<WaterEntry> entries) {
    final csvRows = [
      // Header row
      ['Date', 'Time', 'Amount (ml)', 'Drink Type', 'Hydration Amount (ml)']
    ];

    // Sort entries by timestamp
    final sortedEntries = List<WaterEntry>.from(entries)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Add data rows
    for (final entry in sortedEntries) {
      csvRows.add([
        _formatDateForCSV(entry.timestamp),
        _formatTimeForCSV(entry.timestamp),
        entry.amount.toString(),
        entry.drinkType,
        entry.hydrationAmount.toString(),
      ]);
    }

    // Convert to CSV string
    return csvRows.map((row) => row.join(',')).join('\n');
  }

  /// Format date for CSV export (YYYY-MM-DD)
  String _formatDateForCSV(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Format time for CSV export (HH:MM:SS)
  String _formatTimeForCSV(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  /// Get the appropriate file extension for the export format
  String getFileExtension(HealthDataFormat format) {
    switch (format) {
      case HealthDataFormat.appleHealth:
        return 'xml';
      case HealthDataFormat.googleFit:
        return 'json';
      case HealthDataFormat.csv:
        return 'csv';
      case HealthDataFormat.json:
        return 'json';
    }
  }

  /// Get the appropriate MIME type for the export format
  String getMimeType(HealthDataFormat format) {
    switch (format) {
      case HealthDataFormat.appleHealth:
        return 'application/xml';
      case HealthDataFormat.googleFit:
        return 'application/json';
      case HealthDataFormat.csv:
        return 'text/csv';
      case HealthDataFormat.json:
        return 'application/json';
    }
  }
}
