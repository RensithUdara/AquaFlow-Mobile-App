import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

/// Widget for quick water add buttons
class QuickAddButtons extends StatelessWidget {
  /// Callback when an amount is selected
  final Function(int) onAmountSelected;

  /// Constructor for quick add buttons widget
  const QuickAddButtons({
    super.key,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 10,
      runSpacing: 10,
      children: AppConstants.quickAddAmounts.map((amount) {
        return _buildQuickAddButton(context, amount);
      }).toList(),
    );
  }

  /// Build a single quick add button
  Widget _buildQuickAddButton(BuildContext context, int amount) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onAmountSelected(amount),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.deepBlue.withOpacity(0.15)
                : AppColors.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.deepBlue.withOpacity(0.3)
                  : AppColors.lightBlue.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.water_drop_rounded,
                    color: isDarkMode ? AppColors.lightBlue : AppColors.primaryBlue,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+$amount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.lightBlue : AppColors.primaryBlue,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'ml',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? AppColors.lightBlue.withOpacity(0.7) : AppColors.deepBlue.withOpacity(0.7),
                    ),
              ),
          ],
        ),
      ),
    );

  }
}
