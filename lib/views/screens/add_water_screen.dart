import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/notification_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/water_tracking_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/utility_service.dart';

/// Screen for adding water entries
class AddWaterScreen extends StatefulWidget {
  const AddWaterScreen({super.key});

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  int _selectedAmount = 250;
  String _selectedDrinkType = 'water';
  DateTime _selectedTime = DateTime.now();

  // List of predefined amounts
  final List<int> _predefinedAmounts = AppConstants.quickAddAmounts;

  // List of available drink types
  final List<Map<String, dynamic>> _drinkTypes = [
    {'name': 'water', 'icon': Icons.water_drop, 'color': AppColors.primaryBlue},
    {'name': 'coffee', 'icon': Icons.coffee, 'color': Colors.brown},
    {'name': 'tea', 'icon': Icons.emoji_food_beverage, 'color': Colors.green},
    {'name': 'juice', 'icon': Icons.local_drink, 'color': Colors.orange},
    {'name': 'soda', 'icon': Icons.bubble_chart, 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Water'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Water container visualization
              _buildWaterVisualization(context),

              const SizedBox(height: 24),

              // Amount slider
              _buildAmountSlider(context, isDarkMode),

              const SizedBox(height: 24),

              // Quick amount buttons
              _buildQuickAmountButtons(context, isDarkMode),

              const SizedBox(height: 24),

              // Drink type selector
              _buildDrinkTypeSelector(context, isDarkMode),

              const SizedBox(height: 24),

              // Time selector
              _buildTimeSelector(context, isDarkMode),

              const SizedBox(height: 32),

              // Add button
              ElevatedButton.icon(
                onPressed: _addWater,
                icon: const Icon(Icons.add),
                label: const Text('Add Water'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build water container visualization
  Widget _buildWaterVisualization(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Glass container
          Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.glassBorderDark
                    : AppColors.glassBorder,
                width: 2,
              ),
              color: Colors.transparent,
            ),
          ),

          // Water fill
          AnimatedContainer(
            duration: AppConstants.mediumAnimationDuration,
            width: 116,
            height: 175 * (_selectedAmount / 1000).clamp(0.0, 1.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              color: _getDrinkColor(),
            ),
          ),

          // Amount text
          Positioned(
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$_selectedAmount ${AppConstants.mlUnit}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build amount slider
  Widget _buildAmountSlider(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Amount',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: _selectedAmount.toDouble(),
          min: 50,
          max: 1000,
          divisions: 19,
          label: '$_selectedAmount ${AppConstants.mlUnit}',
          onChanged: (value) {
            setState(() {
              _selectedAmount = value.round();
            });
          },
          activeColor: _getDrinkColor(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '50 ${AppConstants.mlUnit}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
            ),
            Text(
              '1000 ${AppConstants.mlUnit}',
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
  }

  /// Build quick amount buttons
  Widget _buildQuickAmountButtons(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Quick Select',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: _predefinedAmounts.map((amount) {
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedAmount = amount;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedAmount == amount
                      ? _getDrinkColor().withOpacity(0.2)
                      : isDarkMode
                          ? AppColors.darkSurfaceBackground
                          : AppColors.lightSurfaceBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedAmount == amount
                        ? _getDrinkColor()
                        : isDarkMode
                            ? AppColors.darkHintText
                            : AppColors.lightHintText,
                    width: 1,
                  ),
                ),
                child: Text(
                  '$amount ${AppConstants.mlUnit}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            _selectedAmount == amount ? FontWeight.bold : null,
                        color:
                            _selectedAmount == amount ? _getDrinkColor() : null,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build drink type selector
  Widget _buildDrinkTypeSelector(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Drink Type',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: _drinkTypes.map((drinkType) {
            final isSelected = _selectedDrinkType == drinkType['name'];

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedDrinkType = drinkType['name'];
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? drinkType['color'].withOpacity(0.2)
                          : isDarkMode
                              ? AppColors.darkSurfaceBackground
                              : AppColors.lightSurfaceBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? drinkType['color']
                            : isDarkMode
                                ? AppColors.darkHintText
                                : AppColors.lightHintText,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      drinkType['icon'],
                      color: isSelected ? drinkType['color'] : null,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drinkType['name'].toString().toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : null,
                          color: isSelected ? drinkType['color'] : null,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build time selector
  Widget _buildTimeSelector(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Time',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkSurfaceBackground
                  : AppColors.lightSurfaceBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.darkHintText
                    : AppColors.lightHintText,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      UtilityService.formatTime(_selectedTime),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Text(
                  'Change',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Open time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  /// Add water entry and navigate back
  void _addWater() {
    final waterController = context.read<WaterTrackingController>();

    waterController.addWaterEntry(
      _selectedAmount,
      drinkType: _selectedDrinkType,
      timestamp: _selectedTime,
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

    // Show success message and go back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${UtilityService.formatAmount(_selectedAmount)}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  /// Get color based on selected drink type
  Color _getDrinkColor() {
    for (final drinkType in _drinkTypes) {
      if (drinkType['name'] == _selectedDrinkType) {
        return drinkType['color'];
      }
    }
    return AppColors.primaryBlue;
  }
}
