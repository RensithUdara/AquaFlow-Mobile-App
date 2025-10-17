import 'package:uuid/uuid.dart';
import 'drink_type.dart';

/// Model for representing a single water intake entry
class WaterEntry {
  /// Unique identifier for the water entry
  final String id;

  /// Amount of drink consumed in milliliters
  final int amount;

  /// Timestamp when the drink was consumed
  final DateTime timestamp;

  /// Type of drink (water, tea, coffee, etc.)
  final String drinkType;

  /// Get the actual hydration amount considering the drink type's coefficient
  int get hydrationAmount {
    final coefficient = DrinkType.getByName(drinkType).hydrationCoefficient;
    return (amount * coefficient).round();
  }

  /// Constructor for creating a water entry
  WaterEntry({
    String? id,
    required this.amount,
    required this.timestamp,
    this.drinkType = 'water',
  }) : id = id ?? const Uuid().v4();

  /// Create a copy of this WaterEntry but with the given fields replaced with new values
  WaterEntry copyWith({
    String? id,
    int? amount,
    DateTime? timestamp,
    String? drinkType,
  }) {
    return WaterEntry(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      drinkType: drinkType ?? this.drinkType,
    );
  }

  /// Convert WaterEntry to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'drinkType': drinkType,
    };
  }

  /// Create a WaterEntry from a map (JSON deserialization)
  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      id: json['id'] as String,
      amount: json['amount'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      drinkType: json['drinkType'] as String? ?? 'water',
    );
  }
}
