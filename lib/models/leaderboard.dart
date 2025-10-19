import 'package:uuid/uuid.dart';

/// Time period for leaderboard ranking
enum LeaderboardPeriod {
  daily,
  weekly,
  monthly,
  allTime,
}

/// Represents a user's entry in the leaderboard
class LeaderboardEntry {
  /// User ID
  final String userId;

  /// Display name of the user
  final String displayName;

  /// Score or amount (e.g., water consumed in ml)
  final int score;

  /// Current rank in the leaderboard
  final int rank;

  /// Previous rank in the leaderboard
  final int? previousRank;

  /// Whether this is the current user's entry
  final bool isCurrentUser;

  /// Constructor for creating a leaderboard entry
  LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.score,
    required this.rank,
    this.previousRank,
    this.isCurrentUser = false,
  });

  /// Get rank change (positive for improvement, negative for decline)
  int? get rankChange =>
      previousRank != null ? previousRank! - rank : null;

  /// Convert leaderboard entry to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'score': score,
      'rank': rank,
      'previousRank': previousRank,
      'isCurrentUser': isCurrentUser,
    };
  }

  /// Create a leaderboard entry from a map (JSON deserialization)
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      score: json['score'] as int,
      rank: json['rank'] as int,
      previousRank: json['previousRank'] as int?,
      isCurrentUser: json['isCurrentUser'] as bool,
    );
  }
}

/// Model representing a leaderboard
class Leaderboard {
  /// Unique identifier for the leaderboard
  final String id;

  /// Title of the leaderboard
  final String title;

  /// Period for the leaderboard
  final LeaderboardPeriod period;

  /// Start date of the period
  final DateTime startDate;

  /// End date of the period
  final DateTime endDate;

  /// List of entries in the leaderboard
  final List<LeaderboardEntry> entries;

  /// Last updated timestamp
  final DateTime lastUpdated;

  /// Constructor for creating a leaderboard
  Leaderboard({
    String? id,
    required this.title,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.entries,
    DateTime? lastUpdated,
  })  : id = id ?? const Uuid().v4(),
        lastUpdated = lastUpdated ?? DateTime.now();

  /// Get top N entries
  List<LeaderboardEntry> getTopEntries(int count) {
    return entries.take(count).toList();
  }

  /// Get entries around the current user
  List<LeaderboardEntry> getEntriesAroundUser(String userId, int range) {
    final userIndex = entries.indexWhere((e) => e.userId == userId);
    if (userIndex == -1) return [];

    final start = (userIndex - range).clamp(0, entries.length);
    final end = (userIndex + range + 1).clamp(0, entries.length);
    return entries.sublist(start, end);
  }

  /// Convert leaderboard to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'period': period.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'entries': entries.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Create a leaderboard from a map (JSON deserialization)
  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      id: json['id'] as String,
      title: json['title'] as String,
      period: LeaderboardPeriod.values[json['period'] as int],
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      entries: (json['entries'] as List)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}