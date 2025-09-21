import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/notification_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/notification_settings.dart';
import '../../models/user_profile.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/utility_service.dart';

/// Screen for app settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late final TextEditingController _dailyGoalController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();

    // Initialize form controllers
    final settingsController = context.read<SettingsController>();
    _dailyGoalController = TextEditingController(
      text: settingsController.userProfile.dailyGoal.toString(),
    );
    _weightController = TextEditingController(
      text: settingsController.userProfile.weight.toString(),
    );
  }

  @override
  void dispose() {
    _dailyGoalController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile settings
              _buildProfileSettings(context),

              const SizedBox(height: 24),

              // Notification settings
              _buildNotificationSettings(context),

              const SizedBox(height: 24),

              // App settings
              _buildAppSettings(context),

              const SizedBox(height: 32),

              // Save button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Settings'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build profile settings section
  Widget _buildProfileSettings(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      color: isDarkMode
          ? AppColors.darkSecondaryBackground
          : AppColors.lightSecondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Text(
                    'Profile Settings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Daily goal
              TextFormField(
                controller: _dailyGoalController,
                decoration: const InputDecoration(
                  labelText: 'Daily Water Goal (ml)',
                  helperText: 'Recommended: 2000-3000 ml',
                  prefixIcon: Icon(Icons.water_drop),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal';
                  }
                  final goal = int.tryParse(value);
                  if (goal == null) {
                    return 'Please enter a valid number';
                  }
                  if (goal < 500 || goal > 5000) {
                    return 'Goal should be between 500-5000 ml';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  helperText: 'Used to calculate recommended intake',
                  prefixIcon: Icon(Icons.fitness_center),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Please enter a valid number';
                  }
                  if (weight < 30 || weight > 200) {
                    return 'Weight should be between 30-200 kg';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Activity level
              _buildActivityLevelSelector(context, settingsController),

              const SizedBox(height: 16),

              // Recommended intake
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryBlue.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended Daily Intake',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          UtilityService.formatAmount(
                            settingsController.getRecommendedIntake(),
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryBlue,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: TextButton.icon(
                  onPressed: _applyRecommendedIntake,
                  icon: const Icon(Icons.check),
                  label: const Text('Apply Recommended'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build notification settings section
  Widget _buildNotificationSettings(BuildContext context) {
    final notificationController = context.watch<NotificationController>();
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      color: isDarkMode
          ? AppColors.darkSecondaryBackground
          : AppColors.lightSecondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications),
                const SizedBox(width: 8),
                Text(
                  'Notification Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Enable notifications
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive reminders to drink water'),
              value: notificationController.isEnabled,
              onChanged: (value) async {
                await notificationController.toggleNotifications(value);
              },
              secondary: const Icon(Icons.notifications_active),
            ),

            const Divider(),

            // Smart reminders
            SwitchListTile(
              title: const Text('Smart Reminders'),
              subtitle: const Text('Adapt to your daily schedule'),
              value: notificationController.smartRemindersEnabled,
              onChanged: notificationController.isEnabled
                  ? (value) async {
                      await notificationController.toggleSmartReminders(value);
                    }
                  : null,
              secondary: const Icon(Icons.auto_awesome),
            ),

            const Divider(),

            // Scheduled reminders
            ListTile(
              title: const Text('Scheduled Reminders'),
              subtitle: Text(
                '${notificationController.reminderTimes.length} reminders configured',
              ),
              leading: const Icon(Icons.schedule),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: notificationController.isEnabled
                    ? () async {
                        await notificationController.refreshSchedule();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification schedule refreshed'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
                tooltip: 'Refresh schedule',
              ),
            ),

            if (notificationController.isEnabled) ...[
              const SizedBox(height: 8),

              // List of reminder times
              ...notificationController.reminderTimes.asMap().entries.map(
                    (entry) => _buildReminderTimeItem(
                      context,
                      entry.key,
                      entry.value,
                      notificationController,
                    ),
                  ),

              const SizedBox(height: 8),

              // Add reminder button
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _showAddReminderDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Reminder'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build app settings section
  Widget _buildAppSettings(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      color: isDarkMode
          ? AppColors.darkSecondaryBackground
          : AppColors.lightSecondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings),
                const SizedBox(width: 8),
                Text(
                  'App Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Theme settings
            ListTile(
              title: const Text('App Theme'),
              subtitle: Text(_getThemeModeName(settingsController.themeMode)),
              leading: const Icon(Icons.palette),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showThemeSelector(context),
            ),

            const Divider(),

            // About section
            ListTile(
              title: const Text('About'),
              subtitle: const Text('Version ${AppConstants.appVersion}'),
              leading: const Icon(Icons.info),
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Build activity level selector
  Widget _buildActivityLevelSelector(
    BuildContext context,
    SettingsController settingsController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Level',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ActivityLevel.values.map((level) {
            final isSelected =
                level == settingsController.userProfile.activityLevel;

            return ChoiceChip(
              label: Text(_getActivityLevelName(level)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  settingsController.updateUserProfile(activityLevel: level);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build a reminder time item
  Widget _buildReminderTimeItem(
    BuildContext context,
    int index,
    ReminderTime reminderTime,
    NotificationController controller,
  ) {
    return ListTile(
      title: Text(reminderTime.formattedTime),
      leading: Switch(
        value: reminderTime.isEnabled,
        onChanged: (value) async {
          await controller.updateReminderTime(index, isEnabled: value);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await controller.removeReminderTime(index);
        },
      ),
      onTap: () => _showEditReminderDialog(context, index, reminderTime),
    );
  }

  /// Show dialog to add a new reminder time
  Future<void> _showAddReminderDialog(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && context.mounted) {
      final notificationController = context.read<NotificationController>();
      await notificationController.addReminderTime(
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }

  /// Show dialog to edit an existing reminder time
  Future<void> _showEditReminderDialog(
    BuildContext context,
    int index,
    ReminderTime reminderTime,
  ) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: reminderTime.hour, minute: reminderTime.minute),
    );

    if (pickedTime != null && context.mounted) {
      final notificationController = context.read<NotificationController>();
      await notificationController.updateReminderTime(
        index,
        hour: pickedTime.hour,
        minute: pickedTime.minute,
      );
    }
  }

  /// Show dialog to select app theme
  Future<void> _showThemeSelector(BuildContext context) async {
    final settingsController = context.read<SettingsController>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light'),
                leading: const Icon(Icons.light_mode),
                onTap: () {
                  settingsController.setThemeMode(ThemeMode.light);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Dark'),
                leading: const Icon(Icons.dark_mode),
                onTap: () {
                  settingsController.setThemeMode(ThemeMode.dark);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('System'),
                leading: const Icon(Icons.settings_system_daydream),
                onTap: () {
                  settingsController.setThemeMode(ThemeMode.system);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show about dialog
  Future<void> _showAboutDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About AquaFlow'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AquaFlow is a water tracking app that helps you stay hydrated with smart reminders, personalized goals, and simple tracking.',
              ),
              SizedBox(height: 16),
              Text('Version: ${AppConstants.appVersion}'),
              SizedBox(height: 8),
              Text('© 2025 AquaFlow'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Save all settings
  Future<void> _saveSettings() async {
    if (_formKey.currentState?.validate() ?? false) {
      final settingsController = context.read<SettingsController>();

      // Parse form values
      final dailyGoal = int.tryParse(_dailyGoalController.text) ??
          settingsController.userProfile.dailyGoal;
      final weight = double.tryParse(_weightController.text) ??
          settingsController.userProfile.weight;

      // Update profile
      await settingsController.updateUserProfile(
        dailyGoal: dailyGoal,
        weight: weight,
      );

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Apply recommended intake as daily goal
  void _applyRecommendedIntake() {
    final settingsController = context.read<SettingsController>();
    final recommendedIntake = settingsController.getRecommendedIntake();

    setState(() {
      _dailyGoalController.text = recommendedIntake.toString();
    });
  }

  /// Get name for theme mode
  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get name for activity level
  String _getActivityLevelName(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderate';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.extraActive:
        return 'Extra Active';
    }
  }
}
