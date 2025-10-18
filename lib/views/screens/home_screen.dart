import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/notification_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/water_tracking_controller.dart';
import '../../models/user_profile.dart';
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

  /// Small widget to show streaks and period progress
  Widget _buildStreakSummary(BuildContext context, UserProfile profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: AppConstants.cardElevation,
      color: isDark
          ? AppColors.darkSurfaceBackground
          : AppColors.lightSurfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('Streak', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                Text('${profile.currentStreak} days',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Longest: ${profile.longestStreak}d',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Container(
                width: 1,
                height: 48,
                color:
                    isDark ? AppColors.darkHintText : AppColors.lightHintText),
            Column(
              children: [
                Text('Weekly', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                // Placeholder progress; details available in History screen
                Text('View in History',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).primaryColor)),
              ],
            ),
            Container(
                width: 1,
                height: 48,
                color:
                    isDark ? AppColors.darkHintText : AppColors.lightHintText),
            Column(
              children: [
                Text('Monthly', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                Text('View in History',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).primaryColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build daily goal section at the top
  Widget _buildDailyGoalSection(BuildContext context) {
    final waterController = context.watch<WaterTrackingController>();
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);
    // Daily section doesn't compute total hydration here; progress section will compute it

    return Container(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      color: isDarkMode
          ? AppColors.darkSecondaryBackground
          : AppColors.lightSecondaryBackground,
      child: Column(
        children: [
          Text(
            'Daily Target',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Your Daily Water Goal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            UtilityService.formatAmount(
                waterController.dailyGoal?.targetAmount ??
                    settingsController.userProfile.dailyGoal),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap to start tracking your daily water intake!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          // Temperature input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.thermostat_outlined, size: 18),
              const SizedBox(width: 6),
              Text(
                'Temperature',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: AppConstants.baseTemperature.toInt().toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    suffixText: '°C',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  ),
                  onFieldSubmitted: (value) {
                    final t = double.tryParse(value);
                    if (t != null) {
                      // Calculate recommended intake using user profile and temperature
                      final recommended = settingsController.userProfile
                          .calculateRecommendedIntake(temperatureCelsius: t);
                      // Apply as today's daily goal
                      waterController.setDailyGoal(recommended);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Streak & achievements summary
          _buildStreakSummary(context, settingsController.userProfile),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _navigateToAddWater(context),
            child: const Text('Start Tracking'),
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
    // Compute hydration amount for progress display
    final entries = waterController.entries;
    int hydrationAmount = 0;
    for (final e in entries) {
      hydrationAmount += e.hydrationAmount;
    }

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
              hydrationAmount: hydrationAmount,
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
