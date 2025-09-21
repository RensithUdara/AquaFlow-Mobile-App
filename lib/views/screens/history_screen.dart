import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/history_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/utility_service.dart';

/// Screen for viewing water intake history
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyController = context.watch<HistoryController>();
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.contentPadding),
        child: Column(
          children: [
            // Date range selector
            _buildDateRangeSelector(context, historyController, isDarkMode),
            
            const SizedBox(height: 16),
            
            // Statistics summary
            _buildStatisticsSummary(context, historyController, isDarkMode),
            
            const SizedBox(height: 16),
            
            // Date entries list
            Expanded(
              child: _buildHistoryList(context, historyController, isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  /// Build date range selector
  Widget _buildDateRangeSelector(
    BuildContext context, 
    HistoryController historyController,
    bool isDarkMode,
  ) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      color: isDarkMode 
          ? AppColors.darkSecondaryBackground 
          : AppColors.lightSecondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: historyController.goToPrevious,
                  tooltip: 'Previous',
                ),
                _buildRangeTitle(context, historyController),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _canGoForward(historyController)
                      ? historyController.goToNext
                      : null,
                  tooltip: 'Next',
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Range selector chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRangeChip(
                  context, 
                  'Day', 
                  historyController.currentRange == DateRange.day,
                  () => historyController.changeRange(DateRange.day),
                ),
                _buildRangeChip(
                  context, 
                  'Week', 
                  historyController.currentRange == DateRange.week,
                  () => historyController.changeRange(DateRange.week),
                ),
                _buildRangeChip(
                  context, 
                  'Month', 
                  historyController.currentRange == DateRange.month,
                  () => historyController.changeRange(DateRange.month),
                ),
                _buildRangeChip(
                  context, 
                  'Year', 
                  historyController.currentRange == DateRange.year,
                  () => historyController.changeRange(DateRange.year),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build statistics summary card
  Widget _buildStatisticsSummary(
    BuildContext context, 
    HistoryController historyController,
    bool isDarkMode,
  ) {
    final stats = historyController.getStatistics();
    
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
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Stats grid
            Row(
              children: [
                _buildStatItem(
                  context,
                  'Total Intake',
                  UtilityService.formatAmount(stats.totalIntake),
                  Icons.water_drop,
                  AppColors.primaryBlue,
                ),
                _buildStatItem(
                  context,
                  'Average',
                  UtilityService.formatAmount(stats.averageIntake),
                  Icons.trending_up,
                  AppColors.aquaBlue,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                _buildStatItem(
                  context,
                  'Days Completed',
                  '${stats.daysCompleted}/${stats.daysTracked}',
                  Icons.check_circle,
                  AppColors.successGreen,
                ),
                _buildStatItem(
                  context,
                  'Completion',
                  '${(stats.completionRate * 100).toStringAsFixed(0)}%',
                  Icons.star,
                  AppColors.warningOrange,
                ),
              ],
            ),
            
            if (stats.bestDay != null) ...[
              const SizedBox(height: 12),
              Text(
                'Best Day: ${UtilityService.formatDate(stats.bestDay!)} - ${UtilityService.formatAmount(stats.highestAmount)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build history list
  Widget _buildHistoryList(
    BuildContext context, 
    HistoryController historyController,
    bool isDarkMode,
  ) {
    final dates = historyController.datesInRange;
    
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
            Text(
              'History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Expanded(
              child: dates.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        return _buildHistoryItem(
                          context,
                          date,
                          historyController,
                          isDarkMode,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state for no history
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.water_drop_outlined,
            size: 60,
            color: AppColors.neutralGray,
          ),
          const SizedBox(height: 16),
          Text(
            'No history data available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your water intake!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  /// Build a history item for a specific date
  Widget _buildHistoryItem(
    BuildContext context,
    DateTime date,
    HistoryController historyController,
    bool isDarkMode,
  ) {
    final amount = historyController.getAmountForDate(date);
    final progress = historyController.getProgressForDate(date);
    final isCompleted = historyController.isGoalCompletedForDate(date);
    
    Color progressColor;
    if (isCompleted) {
      progressColor = isDarkMode 
          ? AppColors.darkGoalAchieved 
          : AppColors.lightGoalAchieved;
    } else if (progress > 0) {
      progressColor = isDarkMode 
          ? AppColors.darkGoalPartial 
          : AppColors.lightGoalPartial;
    } else {
      progressColor = isDarkMode 
          ? AppColors.darkGoalNotStarted 
          : AppColors.lightGoalNotStarted;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isDarkMode 
                ? AppColors.darkHintText.withOpacity(0.3) 
                : AppColors.lightHintText.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Text(
          UtilityService.formatDate(date),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: isDarkMode 
                  ? AppColors.darkProgressBackground 
                  : AppColors.lightProgressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              amount > 0
                  ? UtilityService.formatAmount(amount)
                  : 'No data',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Icon(
          isCompleted 
              ? Icons.check_circle 
              : Icons.water_drop_outlined,
          color: progressColor,
        ),
      ),
    );
  }

  /// Build range title based on current range
  Widget _buildRangeTitle(BuildContext context, HistoryController controller) {
    final date = controller.referenceDate;
    String title;
    
    switch (controller.currentRange) {
      case DateRange.day:
        title = UtilityService.formatDate(date);
        break;
      case DateRange.week:
        final weekStart = UtilityService.startOfWeek(date);
        final weekEnd = UtilityService.endOfWeek(date);
        title = '${UtilityService.formatDate(weekStart, format: 'MMM d')} - ${UtilityService.formatDate(weekEnd, format: 'MMM d, yyyy')}';
        break;
      case DateRange.month:
        title = UtilityService.formatDate(date, format: 'MMMM yyyy');
        break;
      case DateRange.year:
        title = UtilityService.formatDate(date, format: 'yyyy');
        break;
    }
    
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  /// Build a chip for range selection
  Widget _buildRangeChip(
    BuildContext context, 
    String label, 
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onTap();
      },
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.darkSurfaceBackground 
          : AppColors.lightSurfaceBackground,
    );
  }

  /// Build a statistic item
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.darkSecondaryText 
                      : AppColors.lightSecondaryText,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Check if we can go forward (can't go beyond current date)
  bool _canGoForward(HistoryController controller) {
    final now = DateTime.now();
    final current = controller.referenceDate;
    
    switch (controller.currentRange) {
      case DateRange.day:
        return current.isBefore(DateTime(now.year, now.month, now.day));
      case DateRange.week:
        final currentWeekStart = UtilityService.startOfWeek(current);
        final nowWeekStart = UtilityService.startOfWeek(now);
        return currentWeekStart.isBefore(nowWeekStart);
      case DateRange.month:
        return current.year < now.year || 
            (current.year == now.year && current.month < now.month);
      case DateRange.year:
        return current.year < now.year;
    }
  }
}