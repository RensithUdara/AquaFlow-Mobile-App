/// Get the current achievement level based on streak
String? getCurrentStreakAchievement() {
  if (_userProfile == null) return null;

  if (_userProfile!.longestStreak >= 90) {
    // Platinum - 90 days
    return 'Platinum';
  } else if (_userProfile!.longestStreak >= 30) {
    // Gold - 30 days
    return 'Gold';
  } else if (_userProfile!.longestStreak >= 14) {
    // Silver - 14 days
    return 'Silver';
  } else if (_userProfile!.longestStreak >= 7) {
    // Bronze - 7 days
    return 'Bronze';
  }
  return null;
}

/// Get the next milestone streak goal
int? getNextStreakMilestone() {
  if (_userProfile == null) return null;
  final milestones = [7, 14, 30, 60, 90, 180, 365];
  for (final milestone in milestones) {
    if (_userProfile!.currentStreak < milestone) {
      return milestone;
    }
  }
  return null;
}

/// Get remaining days to next milestone
int? getDaysToNextMilestone() {
  final nextMilestone = getNextStreakMilestone();
  if (nextMilestone == null || _userProfile == null) return null;
  return (nextMilestone - _userProfile!.currentStreak).toInt();
}
