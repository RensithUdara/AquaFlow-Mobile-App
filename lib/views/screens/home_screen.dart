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
              ? [AppColors.navyBlue.withOpacity(0.9), AppColors.deepBlue.withOpacity(0.7)]
              : [AppColors.lightBlue.withOpacity(0.8), AppColors.aquaBlue.withOpacity(0.6)],
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
                          color: isDarkMode ? Colors.white70 : AppColors.deepBlue,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? AppColors.primaryBlue.withOpacity(0.2) 
                      : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
                      color: isDarkMode ? AppColors.lightBlue : AppColors.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      UtilityService.formatAmount(goalAmount),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDarkMode ? Colors.white : AppColors.deepBlue,
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
                    color: isDarkMode ? AppColors.lightBlue : AppColors.deepBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? AppColors.lightBlue.withOpacity(0.2)
                      : Colors.white.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

    return Container(
      // Added padding at the bottom to prevent overflow
      padding: const EdgeInsets.only(
        left: AppConstants.contentPadding,
        right: AppConstants.contentPadding,
        top: AppConstants.contentPadding,
        bottom: AppConstants.contentPadding +
            80, // Extra padding for the bottom nav bar
      ),
      color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      child: Column(
        children: [
          Text(
            'Hydration Tracker',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),

          // Water progress indicator
          Expanded(
            child: WaterProgressIndicator(
              progress: waterController.progressPercentage,
              currentAmount: waterController.totalAmount,
              targetAmount: waterController.dailyGoal?.targetAmount ??
                  settingsController.userProfile.dailyGoal,
              isDarkMode: isDarkMode,
            ),
          ),

          const SizedBox(height: 20),

          // Quick add buttons
          QuickAddButtons(
            onAmountSelected: (amount) => _quickAddWater(context, amount),
          ),

          const SizedBox(height: 10),

          // Add custom button
          OutlinedButton.icon(
            onPressed: () => _navigateToAddWater(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Water'),
          ),
        ],
      ),
    );
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
}
