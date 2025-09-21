import 'package:flutter/material.dart';

/// Class containing all the app color constants
class AppColors {
  // Water Blue Spectrum
  static const Color primaryBlue = Color(0xFF2196F3); // Main brand color
  static const Color lightBlue = Color(0xFF64B5F6);   // Secondary actions, highlights
  static const Color deepBlue = Color(0xFF1976D2);    // Headers, primary buttons
  static const Color aquaBlue = Color(0xFF00BCD4);    // Progress indicators, success states
  static const Color navyBlue = Color(0xFF0D47A1);    // Dark accents, text emphasis

  // Supporting Colors
  static const Color successGreen = Color(0xFF4CAF50); // Goal completed, positive feedback
  static const Color warningOrange = Color(0xFFFF9800); // Reminders, attention needed
  static const Color errorRed = Color(0xFFF44336);     // Validation errors, negative states
  static const Color neutralGray = Color(0xFF9E9E9E);  // Disabled states, secondary text

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);      // Main screen background
  static const Color lightSecondaryBackground = Color(0xFFF8F9FA); // Card backgrounds, sections
  static const Color lightSurfaceBackground = Color(0xFFF5F5F5);  // Input fields, containers
  static const Color lightElevatedSurface = Color(0xFFFFFFFF);    // Floating cards, modals

  static const Color lightPrimaryText = Color(0xFF212121);      // Main content, headings
  static const Color lightSecondaryText = Color(0xFF757575);    // Descriptions, labels
  static const Color lightHintText = Color(0xFFBDBDBD);         // Placeholders, disabled text
  static const Color lightInverseText = Color(0xFFFFFFFF);      // Text on colored backgrounds

  static const Color lightProgressFill = Color(0xFF00BCD4);     // Water level, goal progress
  static const Color lightProgressBackground = Color(0xFFE0F2F1);
  static const Color lightProgressTrack = Color(0xFFB2DFDB);

  static const Color lightGoalAchieved = Color(0xFF4CAF50);
  static const Color lightGoalPartial = Color(0xFFFF9800);
  static const Color lightGoalNotStarted = Color(0xFFE0E0E0);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);        // Main screen background
  static const Color darkSecondaryBackground = Color(0xFF1E1E1E); // Card backgrounds, sections
  static const Color darkSurfaceBackground = Color(0xFF2C2C2C);  // Input fields, containers
  static const Color darkElevatedSurface = Color(0xFF383838);    // Floating cards, modals

  static const Color darkPrimaryText = Color(0xFFFFFFFF);       // Main content, headings
  static const Color darkSecondaryText = Color(0xFFB3B3B3);     // Descriptions, labels
  static const Color darkHintText = Color(0xFF666666);          // Placeholders, disabled text
  static const Color darkInverseText = Color(0xFF121212);       // Text on light backgrounds

  static const Color darkProgressFill = Color(0xFF26C6DA);      // Brighter cyan for dark mode
  static const Color darkProgressBackground = Color(0xFF1E2A2D);
  static const Color darkProgressTrack = Color(0xFF2C3E3F);

  static const Color darkGoalAchieved = Color(0xFF66BB6A);      // Lighter green
  static const Color darkGoalPartial = Color(0xFFFFB74D);       // Lighter orange
  static const Color darkGoalNotStarted = Color(0xFF424242);

  // Water Visualization
  static const Color waterDrop = Color(0xFF2196F3);
  static const Color waterDropDark = Color(0xFF64B5F6);
  static const Color waterSurface = Color(0xFFE3F2FD);
  static const Color waterSurfaceDark = Color(0xFF1A2332);
  static const Color glassContainer = Color(0xFFF5F5F5);
  static const Color glassContainerDark = Color(0xFF2C2C2C);
  static const Color glassBorder = Color(0xFFE0E0E0);
  static const Color glassBorderDark = Color(0xFF424242);
}