import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/utility_service.dart';
import 'dart:math' as math;

/// Widget to display water progress as a circular indicator
class WaterProgressIndicator extends StatelessWidget {
  /// Progress value from 0.0 to 1.0
  final double progress;
  
  /// Current amount of water consumed
  final int currentAmount;
  
  /// Target amount for the day
  final int targetAmount;
  
  /// Whether to use dark theme colors
  final bool isDarkMode;

  /// Constructor for water progress indicator
  const WaterProgressIndicator({
    Key? key,
    required this.progress,
    required this.currentAmount,
    required this.targetAmount,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress circle
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle
              Container(
                width: 220,
                height: 220,
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
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
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
                width: 160,
                height: 160,
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
                    UtilityService.formatAmount(currentAmount),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode 
                          ? AppColors.darkPrimaryText 
                          : AppColors.lightPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'of ${UtilityService.formatAmount(targetAmount)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDarkMode 
                          ? AppColors.darkSecondaryText 
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Motivational message
          Text(
            UtilityService.getMotivationalMessage(progress),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: _getProgressColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
      return isDarkMode ? AppColors.darkGoalAchieved : AppColors.lightGoalAchieved;
    } else if (progress >= 0.7) {
      return AppColors.primaryBlue;
    } else if (progress >= 0.4) {
      return AppColors.lightBlue;
    } else {
      return isDarkMode ? AppColors.darkGoalPartial : AppColors.lightGoalPartial;
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