import 'package:uuid/uuid.dart';

/// Represents the format for exporting health data
enum HealthDataFormat {
  appleHealth,
  googleFit,
  csv,
  json,
}

/// Model representing exportable health data
class HealthData {
  /// Unique identifier for the health data export
  final String id;

  /// Date range start for the export
  final DateTime startDate;

  /// Date range end for the export
  final DateTime endDate;

  /// Format of the exported data
  final HealthDataFormat format;

  /// Map of water entries data
  final Map<String, dynamic> waterData;

  /// Map of additional metadata
  final Map<String, dynamic> metadata;

  /// Constructor for creating health data export
  HealthData({
    String? id,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.waterData,
    required this.metadata,
  }) : id = id ?? const Uuid().v4();

  /// Convert health data to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'format': format.index,
      'waterData': waterData,
      'metadata': metadata,
    };
  }

  /// Create health data from a map (JSON deserialization)
  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      format: HealthDataFormat.values[json['format'] as int],
      waterData: json['waterData'] as Map<String, dynamic>,
      metadata: json['metadata'] as Map<String, dynamic>,
    );
  }

  /// Create a copy of this health data with specified fields replaced with new values
  HealthData copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    HealthDataFormat? format,
    Map<String, dynamic>? waterData,
    Map<String, dynamic>? metadata,
  }) {
    return HealthData(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      format: format ?? this.format,
      waterData: waterData ?? this.waterData,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Generate metadata for the export
  static Map<String, dynamic> generateMetadata() {
    return {
      'exportedAt': DateTime.now().toIso8601String(),
      'appName': 'AquaFlow',
      'version': '1.0.0',
      'dataType': 'hydration',
      'unit': 'milliliters',
    };
  }
}
