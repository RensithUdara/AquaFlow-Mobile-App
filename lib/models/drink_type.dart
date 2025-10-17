import 'package:flutter/material.dart';

/// Model representing different types of drinks and their hydration coefficients
class DrinkType {
  /// Name of the drink type
  final String name;

  /// Icon to display for this drink type
  final IconData icon;

  /// Color associated with this drink type
  final Color color;

  /// Hydration coefficient (how much this drink contributes to hydration)
  /// 1.0 means 100% counts towards hydration, 0.5 means 50%, etc.
  final double hydrationCoefficient;

  /// Constructor for creating a drink type
  const DrinkType({
    required this.name,
    required this.icon,
    required this.color,
    required this.hydrationCoefficient,
  });

  /// List of predefined drink types with their hydration coefficients
  static const List<DrinkType> predefinedTypes = [
    DrinkType(
      name: 'water',
      icon: Icons.water_drop,
      color: Colors.blue,
      hydrationCoefficient: 1.0,
    ),
    DrinkType(
      name: 'tea',
      icon: Icons.emoji_food_beverage,
      color: Colors.green,
      hydrationCoefficient: 0.8, // Tea is slightly diuretic
    ),
    DrinkType(
      name: 'coffee',
      icon: Icons.coffee,
      color: Colors.brown,
      hydrationCoefficient: 0.6, // Coffee is more diuretic
    ),
    DrinkType(
      name: 'juice',
      icon: Icons.local_drink,
      color: Colors.orange,
      hydrationCoefficient: 0.85, // Juice contains water but also sugars
    ),
    DrinkType(
      name: 'sports drink',
      icon: Icons.sports_bar,
      color: Colors.lightBlue,
      hydrationCoefficient: 0.9, // Sports drinks are good for hydration
    ),
    DrinkType(
      name: 'milk',
      icon: Icons.breakfast_dining,
      color: Colors.grey,
      hydrationCoefficient: 0.95, // Milk is good for hydration
    ),
  ];

  /// Get a drink type by name
  static DrinkType getByName(String name) {
    return predefinedTypes.firstWhere(
      (type) => type.name == name,
      orElse: () => predefinedTypes.first, // Default to water
    );
  }
}