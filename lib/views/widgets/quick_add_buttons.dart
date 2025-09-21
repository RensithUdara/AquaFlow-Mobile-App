import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_colors.dart';

/// Widget for quick water add buttons
class QuickAddButtons extends StatelessWidget {
  /// Callback when an amount is selected
  final Function(int) onAmountSelected;

  /// Constructor for quick add buttons widget
  const QuickAddButtons({
    Key? key,
    required this.onAmountSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quick Add',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: AppConstants.quickAddAmounts.map((amount) {
            return _buildQuickAddButton(context, amount);
          }).toList(),
        ),
      ],
    );
  }

  /// Build a single quick add button
  Widget _buildQuickAddButton(BuildContext context, int amount) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => onAmountSelected(amount),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode 
              ? AppColors.darkSurfaceBackground 
              : AppColors.lightSurfaceBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$amount',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            Text(
              'ml',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDarkMode 
                    ? AppColors.darkSecondaryText 
                    : AppColors.lightSecondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}