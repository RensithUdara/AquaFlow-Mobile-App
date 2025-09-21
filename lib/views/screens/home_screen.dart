import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/water_tracking_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/utility_service.dart';
import '../widgets/water_progress_indicator.dart';
import '../widgets/quick_add_buttons.dart';
import 'add_water_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

/// Home screen of the app
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddWater(context),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Build daily goal section at the top
  Widget _buildDailyGoalSection(BuildContext context) {
    final waterController = context.watch<WaterTrackingController>();
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      color: isDarkMode ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
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
              settingsController.userProfile.dailyGoal
            ),
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

    return Container(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
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

  /// Build bottom navigation bar
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {}, // Already on home screen
            tooltip: 'Home',
          ),
          
          // History
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _navigateToHistory(context),
            tooltip: 'History',
          ),
          
          // Spacer for FAB
          const SizedBox(width: 40),
          
          // Notifications
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _navigateToSettings(context),
            tooltip: 'Notifications',
          ),
          
          // Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

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

  /// Navigate to add water screen
  void _navigateToAddWater(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWaterScreen()),
    );
  }

  /// Navigate to history screen
  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  /// Navigate to settings screen
  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }
}