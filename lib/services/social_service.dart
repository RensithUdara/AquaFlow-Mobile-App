import 'package:uuid/uuid.dart';

import '../models/friend_connection.dart';
import '../models/hydration_challenge.dart';
import '../models/leaderboard.dart';
import '../models/social.dart';
import '../services/storage_service.dart';
import '../utils/app_constants.dart';

/// Service for managing social interactions and features
class SocialService {
  final StorageService _storageService;

  /// Constructor for social service
  SocialService(this._storageService);

  // Friend Connection Methods

  /// Send a friend request to another user
  Future<FriendConnection> sendFriendRequest(String receiverId) async {
    final currentUser = _storageService.getUserProfile();

    final connection = FriendConnection(
      requesterId: currentUser.userId,
      receiverId: receiverId,
      status: FriendRequestStatus.pending,
      requestedAt: DateTime.now(),
    );

    await _saveFriendConnection(connection);
    return connection;
  }

  /// Accept a friend request
  Future<FriendConnection> acceptFriendRequest(FriendConnection connection) async {
    final updatedConnection = FriendConnection(
      requesterId: connection.requesterId,
      receiverId: connection.receiverId,
      status: FriendRequestStatus.accepted,
      requestedAt: connection.requestedAt,
      respondedAt: DateTime.now(),
    );

    await _saveFriendConnection(updatedConnection);
    return updatedConnection;
  }

  /// Decline a friend request
  Future<FriendConnection> declineFriendRequest(FriendConnection connection) async {
    final updatedConnection = FriendConnection(
      requesterId: connection.requesterId,
      receiverId: connection.receiverId,
      status: FriendRequestStatus.declined,
      requestedAt: connection.requestedAt,
      respondedAt: DateTime.now(),
    );

    await _saveFriendConnection(updatedConnection);
    return updatedConnection;
  }

  // Challenge Methods

  /// Create a new hydration challenge
  Future<HydrationChallenge> createChallenge({
    required String title,
    required String description,
    required ChallengeType type,
    required List<String> participantIds,
    required int targetValue,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final currentUser = _storageService.getUserProfile();

    final challenge = HydrationChallenge(
      title: title,
      description: description,
      type: type,
      creatorId: currentUser.userId,
      participantIds: participantIds,
      targetValue: targetValue,
      startDate: startDate,
      endDate: endDate,
    );

    await _saveChallenge(challenge);
    return challenge;
  }

  /// Update challenge progress for a participant
  Future<void> updateChallengeProgress(
    String challengeId,
    String userId,
    int progress,
  ) async {
    final challenge = await _getChallenge(challengeId);
    if (challenge == null) {
      throw Exception('Challenge not found');
    }

    challenge.updateProgress(userId, progress);
    await _saveChallenge(challenge);
  }

  // Leaderboard Methods

  /// Create or update a leaderboard
  Future<Leaderboard> updateLeaderboard(
    LeaderboardPeriod period,
    List<LeaderboardEntry> entries,
  ) async {
    final now = DateTime.now();
    final (startDate, endDate) = _getLeaderboardDateRange(period, now);

    final leaderboard = Leaderboard(
      title: '${period.name.toUpperCase()} Leaderboard',
      period: period,
      startDate: startDate,
      endDate: endDate,
      entries: entries,
    );

    await _saveLeaderboard(leaderboard);
    return leaderboard;
  }

  /// Get a user's leaderboard rank
  Future<LeaderboardEntry?> getUserLeaderboardEntry(
    String userId,
    LeaderboardPeriod period,
  ) async {
    final leaderboard = await _getLeaderboard(period);
    if (leaderboard == null) return null;

    return leaderboard.entries.firstWhere(
      (entry) => entry.userId == userId,
      orElse: () => throw Exception('User not found in leaderboard'),
    );
  }

  // Activity Methods

  /// Create a new social activity
  Future<SocialActivity> createActivity({
    required String userId,
    required String type,
    required String title,
    required String description,
    required SocialPrivacyLevel privacyLevel,
    Map<String, dynamic>? metadata,
  }) async {
    final activity = SocialActivity(
      userId: userId,
      type: type,
      title: title,
      description: description,
      privacyLevel: privacyLevel,
      metadata: metadata,
    );

    await _saveActivity(activity);
    return activity;
  }

  /// Add a comment to an activity
  Future<SocialComment> addComment(
    String activityId,
    String userId,
    String content,
  ) async {
    final activity = await _getActivity(activityId);
    if (activity == null) {
      throw Exception('Activity not found');
    }

    final comment = SocialComment(
      userId: userId,
      content: content,
    );

    activity.comments.add(comment);
    await _saveActivity(activity);
    return comment;
  }

  /// Like or unlike an activity
  Future<bool> toggleLike(String activityId, String userId) async {
    final activity = await _getActivity(activityId);
    if (activity == null) {
      throw Exception('Activity not found');
    }

    final hasLiked = activity.likedBy.contains(userId);
    if (hasLiked) {
      activity.likedBy.remove(userId);
    } else {
      activity.likedBy.add(userId);
    }

    await _saveActivity(activity);
    return !hasLiked;
  }

  // Helper Methods

  /// Get date range for a leaderboard period
  (DateTime, DateTime) _getLeaderboardDateRange(
    LeaderboardPeriod period,
    DateTime now,
  ) {
    final DateTime startDate;
    final DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (period) {
      case LeaderboardPeriod.daily:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case LeaderboardPeriod.weekly:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case LeaderboardPeriod.monthly:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case LeaderboardPeriod.allTime:
        startDate = DateTime(2020); // App launch date or similar
        break;
    }

    return (startDate, endDate);
  }

  // Storage Methods - These would typically interact with a backend API
  // For now, we'll use local storage as a placeholder

  Future<void> _saveFriendConnection(FriendConnection connection) async {
    // TODO: Implement with backend API
  }

  Future<FriendConnection?> _getFriendConnection(String userId1, String userId2) async {
    // TODO: Implement with backend API
    return null;
  }

  Future<void> _saveChallenge(HydrationChallenge challenge) async {
    // TODO: Implement with backend API
  }

  Future<HydrationChallenge?> _getChallenge(String challengeId) async {
    // TODO: Implement with backend API
    return null;
  }

  Future<void> _saveLeaderboard(Leaderboard leaderboard) async {
    // TODO: Implement with backend API
  }

  Future<Leaderboard?> _getLeaderboard(LeaderboardPeriod period) async {
    // TODO: Implement with backend API
    return null;
  }

  Future<void> _saveActivity(SocialActivity activity) async {
    // TODO: Implement with backend API
  }

  Future<SocialActivity?> _getActivity(String activityId) async {
    // TODO: Implement with backend API
    return null;
  }
}