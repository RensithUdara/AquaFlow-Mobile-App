import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/utility_service.dart';

/// Widget to display water progress as a circular indicator
class WaterProgressIndicator extends StatelessWidget {
  /// Progress value from 0.0 to 1.0
  final double progress;

  /// Current amount of water consumed
  final int currentAmount;

  /// Hydration-adjusted amount (considers drink coefficients)
  final int hydrationAmount;

  /// Target amount for the day
  final int targetAmount;

  /// Whether to use dark theme colors
  final bool isDarkMode;

  /// Constructor for water progress indicator
  const WaterProgressIndicator({
    super.key,
    required this.progress,
    required this.currentAmount,
    required this.hydrationAmount,
    required this.targetAmount,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        // Calculate circle size based on available space
        final maxSize =
            math.min(constraints.maxWidth, constraints.maxHeight * 0.7);
        final circleSize = math.min(220.0, maxSize);
        final progressSize = circleSize * 0.91; // 200/220
        final innerCircleSize = circleSize * 0.73; // 160/220

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress circle
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? AppColors.darkSurfaceBackground
                        : AppColors.lightSurfaceBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                // Progress indicator
                SizedBox(
                  width: progressSize,
                  height: progressSize,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: math.max(
                        6, circleSize * 0.055), // Adaptive stroke width
                    backgroundColor: isDarkMode
                        ? AppColors.darkProgressBackground
                        : AppColors.lightProgressBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(),
                    ),
                  ),
                ),

                // Water level visualization
                Container(
                  width: innerCircleSize,
                  height: innerCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? AppColors.darkSecondaryBackground
                        : AppColors.lightSecondaryBackground,
                  ),
                  child: _buildWaterLevel(context),
                ),

                // Current amount text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      UtilityService.formatAmount(hydrationAmount),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? AppColors.darkPrimaryText
                                    : AppColors.lightPrimaryText,
                                // Adjust text size based on circle size
                                fontSize: math.max(14, innerCircleSize * 0.15),
                              ),
                    ),
                    SizedBox(height: math.max(2, circleSize * 0.018)),
                    Text(
                      'of ${UtilityService.formatAmount(targetAmount)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? AppColors.darkSecondaryText
                                : AppColors.lightSecondaryText,
                            // Adjust text size based on circle size
                            fontSize: math.max(10, innerCircleSize * 0.09),
                          ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: math.max(10, constraints.maxHeight * 0.05)),

            // Motivational message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                UtilityService.getMotivationalMessage(progress),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _getProgressColor(),
                      fontSize: math.max(12, constraints.maxHeight * 0.06),
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),
            // Show raw amount vs hydration-adjusted amount and remaining
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Raw: ${UtilityService.formatAmount(currentAmount)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                      ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hydration: ${UtilityService.formatAmount(hydrationAmount)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getProgressColor(),
                      ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Remaining: ${UtilityService.formatAmount((targetAmount - hydrationAmount).clamp(0, targetAmount))}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                      ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  /// Build water level visualization inside the circle
  Widget _buildWaterLevel(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(fillLevel: progress),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [AppColors.lightBlue.withOpacity(0.7), AppColors.aquaBlue]
                : [AppColors.lightBlue.withOpacity(0.7), AppColors.primaryBlue],
          ),
        ),
      ),
    );
  }

  /// Get color based on progress
  Color _getProgressColor() {
    if (progress >= 1.0) {
      return isDarkMode
          ? AppColors.darkGoalAchieved
          : AppColors.lightGoalAchieved;
    } else if (progress >= 0.7) {
      return AppColors.primaryBlue;
    } else if (progress >= 0.4) {
      return AppColors.lightBlue;
    } else {
      return isDarkMode
          ? AppColors.darkGoalPartial
          : AppColors.lightGoalPartial;
    }
  }
}

/// Custom clipper to create wave effect
class WaveClipper extends CustomClipper<Path> {
  /// Fill level from 0.0 to 1.0
  final double fillLevel;

  /// Wave frequency
  final double frequency = 8.0;

  /// Wave height
  final double amplitude = 5.0;

  /// Constructor for wave clipper
  WaveClipper({required this.fillLevel});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at bottom left
    path.moveTo(0, size.height);

    // Calculate water level from bottom
    final waterLevel = size.height * (1 - fillLevel.clamp(0.0, 1.0));

    // If empty, just return a path with the bottom of the container
    if (fillLevel <= 0.01) {
      path.lineTo(size.width, size.height);
      path.close();
      return path;
    }

    // Create wave effect
    for (int i = 0; i <= size.width.toInt(); i++) {
      final dx = i.toDouble();
      final dy = waterLevel +
          amplitude * math.sin((dx / size.width) * frequency * math.pi);
      path.lineTo(dx, dy);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => true;
}
