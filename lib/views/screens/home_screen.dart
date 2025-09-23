import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/notification_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/water_tracking_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/utility_service.dart';
import '../widgets/quick_add_buttons.dart';
import '../widgets/water_progress_indicator.dart';

/// Home screen of the app
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top section with daily goal
            _buildDailyGoalSection(context),

            // Main section with water progress
            Expanded(
              child: _buildWaterProgressSection(context),
            ),
          ],
        ),
      ),
      // Removed bottom navigation bar as it's already in AppScaffold
    );
  }

  /// Build daily goal section at the top
  Widget _buildDailyGoalSection(BuildContext context) {
    final waterController = context.watch<WaterTrackingController>();
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);
    final goalAmount = waterController.dailyGoal?.targetAmount ??
        settingsController.userProfile.dailyGoal;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.contentPadding,
        vertical: AppConstants.contentPadding / 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  AppColors.navyBlue.withOpacity(0.9),
                  AppColors.deepBlue.withOpacity(0.7)
                ]
              : [
                  AppColors.lightBlue.withOpacity(0.8),
                  AppColors.aquaBlue.withOpacity(0.6)
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Target',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: isDarkMode ? Colors.white : AppColors.navyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your hydration goal for today',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              isDarkMode ? Colors.white70 : AppColors.deepBlue,
                        ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.primaryBlue.withOpacity(0.2)
                      : Colors.white.withOpacity(0.4),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.lightBlue.withOpacity(0.3)
                        : Colors.white.withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.water_drop_rounded,
                      color: isDarkMode
                          ? AppColors.lightBlue
                          : AppColors.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      UtilityService.formatAmount(goalAmount),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color:
                                isDarkMode ? Colors.white : AppColors.deepBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar showing current progress toward daily goal
          LinearProgressIndicator(
            value: waterController.progressPercentage,
            backgroundColor: isDarkMode
                ? AppColors.darkProgressBackground.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              waterController.progressPercentage >= 1.0
                  ? AppColors.successGreen
                  : isDarkMode
                      ? AppColors.lightBlue
                      : AppColors.deepBlue,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(waterController.progressPercentage * 100).toInt()}% of daily goal',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.white70 : AppColors.deepBlue,
                    ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToAddWater(context),
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: isDarkMode ? AppColors.lightBlue : AppColors.deepBlue,
                ),
                label: Text(
                  'Add Water',
                  style: TextStyle(
                    color:
                        isDarkMode ? AppColors.lightBlue : AppColors.deepBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? AppColors.lightBlue.withOpacity(0.2)
                      : Colors.white.withOpacity(0.3),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build water progress section
  Widget _buildWaterProgressSection(BuildContext context) {
    final waterController = context.watch<WaterTrackingController>();
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);
    final goalAmount = waterController.dailyGoal?.targetAmount ??
        settingsController.userProfile.dailyGoal;

    return Container(
      // Added padding at the bottom to prevent overflow
      padding: const EdgeInsets.only(
        left: AppConstants.contentPadding,
        right: AppConstants.contentPadding,
        top: AppConstants.contentPadding / 2,
        bottom: AppConstants.contentPadding +
            80, // Extra padding for the bottom nav bar
      ),
      color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Today's status card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              side: BorderSide(
                color: isDarkMode
                    ? AppColors.darkSurfaceBackground
                    : Colors.grey.shade200,
                width: 1,
              ),
            ),
            color:
                isDarkMode ? AppColors.darkSecondaryBackground : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Hydration',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                                  waterController.progressPercentage,
                                  isDarkMode)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(waterController.progressPercentage),
                          style: TextStyle(
                            color: _getStatusColor(
                                waterController.progressPercentage, isDarkMode),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                          context,
                          'Consumed',
                          UtilityService.formatAmount(
                              waterController.totalAmount),
                          Icons.local_drink_rounded,
                          AppColors.primaryBlue),
                      _buildVerticalDivider(isDarkMode),
                      _buildStatColumn(
                          context,
                          'Goal',
                          UtilityService.formatAmount(goalAmount),
                          Icons.flag_rounded,
                          isDarkMode
                              ? AppColors.lightBlue
                              : AppColors.deepBlue),
                      _buildVerticalDivider(isDarkMode),
                      _buildStatColumn(
                          context,
                          'Remaining',
                          UtilityService.formatAmount(math.max(
                              0, goalAmount - waterController.totalAmount)),
                          Icons.hourglass_bottom_rounded,
                          AppColors.warningOrange),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Water progress indicator
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                side: BorderSide(
                  color: isDarkMode
                      ? AppColors.darkSurfaceBackground
                      : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              color:
                  isDarkMode ? AppColors.darkSecondaryBackground : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: WaterProgressIndicator(
                  progress: waterController.progressPercentage,
                  currentAmount: waterController.totalAmount,
                  targetAmount: goalAmount,
                  isDarkMode: isDarkMode,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick add buttons
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              side: BorderSide(
                color: isDarkMode
                    ? AppColors.darkSurfaceBackground
                    : Colors.grey.shade200,
                width: 1,
              ),
            ),
            color:
                isDarkMode ? AppColors.darkSecondaryBackground : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_circle_rounded,
                        color: isDarkMode
                            ? AppColors.lightBlue
                            : AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quick Add',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  QuickAddButtons(
                    onAmountSelected: (amount) =>
                        _quickAddWater(context, amount),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToAddWater(context),
                      icon: const Icon(Icons.water_drop_rounded),
                      label: const Text('Add Custom Amount'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? AppColors.deepBlue
                            : AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a stat column with label, value and icon
  Widget _buildStatColumn(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  /// Build vertical divider for stats
  Widget _buildVerticalDivider(bool isDarkMode) {
    return Container(
      height: 40,
      width: 1,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
    );
  }

  /// Get color based on progress percentage
  Color _getStatusColor(double progress, bool isDarkMode) {
    if (progress >= 1.0) {
      return AppColors.successGreen;
    } else if (progress >= 0.7) {
      return AppColors.primaryBlue;
    } else if (progress >= 0.4) {
      return AppColors.warningOrange;
    } else {
      return AppColors.errorRed;
    }
  }

  /// Get status text based on progress percentage
  String _getStatusText(double progress) {
    if (progress >= 1.0) {
      return 'Goal Achieved!';
    } else if (progress >= 0.7) {
      return 'Almost There!';
    } else if (progress >= 0.4) {
      return 'Making Progress';
    } else {
      return 'Just Started';
    }
  }
}

// Bottom navigation bar method removed as it's already in AppScaffold

/// Add water using quick add buttons
void _quickAddWater(BuildContext context, int amount) {
  final waterController = context.read<WaterTrackingController>();
  waterController.addWaterEntry(amount);

  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Added ${UtilityService.formatAmount(amount)}'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // Schedule smart reminder if needed
  final notificationController = context.read<NotificationController>();
  if (notificationController.smartRemindersEnabled) {
    notificationController.scheduleSmartReminder(
      waterController.totalAmount,
      waterController.dailyGoal?.targetAmount ??
          context.read<SettingsController>().userProfile.dailyGoal,
    );
  }
}

/// Navigate to add water screen - uses the parent AppScaffold's bottom nav instead
void _navigateToAddWater(BuildContext context) {
  // We don't need to push a new screen since we have bottom navigation in AppScaffold
  // This could be changed to communicate with AppScaffold to change the selected index
  // For now, just show a dialog to add custom water amount

  final waterController = context.read<WaterTrackingController>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Custom Amount'),
      content: TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Amount (ml)',
          hintText: 'Enter custom amount',
        ),
        onSubmitted: (value) {
          final amount = int.tryParse(value);
          if (amount != null && amount > 0) {
            waterController.addWaterEntry(amount);
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Implementation would be added here in a real app
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
