import 'package:uuid/uuid.dart';

/// Privacy level for social interactions
enum SocialPrivacyLevel {
  public,
  friendsOnly,
  private,
}

/// Model representing a social user profile
class SocialProfile {
  /// User ID
  final String userId;

  /// Display name
  final String displayName;

  /// Avatar image URL
  final String? avatarUrl;

  /// Privacy level for the profile
  final SocialPrivacyLevel privacyLevel;

  /// Total achievements earned
  final int totalAchievements;

  /// Current streak
  final int currentStreak;

  /// Longest streak ever
  final int longestStreak;

  /// Number of friends
  final int friendCount;

  /// Number of challenges won
  final int challengesWon;

  /// List of friend IDs
  final List<String> friendIds;

  /// Whether this profile is visible to the current user
  final bool isVisible;

  /// Constructor for creating a social profile
  SocialProfile({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.privacyLevel,
    this.totalAchievements = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.friendCount = 0,
    this.challengesWon = 0,
    List<String>? friendIds,
    this.isVisible = true,
  }) : friendIds = friendIds ?? [];

  /// Convert social profile to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'privacyLevel': privacyLevel.index,
      'totalAchievements': totalAchievements,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'friendCount': friendCount,
      'challengesWon': challengesWon,
      'friendIds': friendIds,
      'isVisible': isVisible,
    };
  }

  /// Create a social profile from a map (JSON deserialization)
  factory SocialProfile.fromJson(Map<String, dynamic> json) {
    return SocialProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      privacyLevel: SocialPrivacyLevel.values[json['privacyLevel'] as int],
      totalAchievements: json['totalAchievements'] as int,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      friendCount: json['friendCount'] as int,
      challengesWon: json['challengesWon'] as int,
      friendIds: List<String>.from(json['friendIds'] as List),
      isVisible: json['isVisible'] as bool,
    );
  }

  /// Create a copy of this profile with specified fields replaced with new values
  SocialProfile copyWith({
    String? userId,
    String? displayName,
    String? avatarUrl,
    SocialPrivacyLevel? privacyLevel,
    int? totalAchievements,
    int? currentStreak,
    int? longestStreak,
    int? friendCount,
    int? challengesWon,
    List<String>? friendIds,
    bool? isVisible,
  }) {
    return SocialProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      totalAchievements: totalAchievements ?? this.totalAchievements,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      friendCount: friendCount ?? this.friendCount,
      challengesWon: challengesWon ?? this.challengesWon,
      friendIds: friendIds ?? this.friendIds,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

/// Model representing a social activity/post
class SocialActivity {
  /// Unique identifier for the activity
  final String id;

  /// User ID of the creator
  final String userId;

  /// Type of activity (achievement, challenge completion, etc.)
  final String type;

  /// Title of the activity
  final String title;

  /// Description or content of the activity
  final String description;

  /// Creation timestamp
  final DateTime createdAt;

  /// Privacy level for the activity
  final SocialPrivacyLevel privacyLevel;

  /// Additional data related to the activity (achievements, challenges, etc.)
  final Map<String, dynamic> metadata;

  /// List of user IDs who liked the activity
  final List<String> likedBy;

  /// List of comments on the activity
  final List<SocialComment> comments;

  /// Constructor for creating a social activity
  SocialActivity({
    String? id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.privacyLevel,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
    List<String>? likedBy,
    List<SocialComment>? comments,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        metadata = metadata ?? {},
        likedBy = likedBy ?? [],
        comments = comments ?? [];

  /// Convert social activity to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'privacyLevel': privacyLevel.index,
      'metadata': metadata,
      'likedBy': likedBy,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }

  /// Create a social activity from a map (JSON deserialization)
  factory SocialActivity.fromJson(Map<String, dynamic> json) {
    return SocialActivity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      privacyLevel: SocialPrivacyLevel.values[json['privacyLevel'] as int],
      metadata: json['metadata'] as Map<String, dynamic>,
      likedBy: List<String>.from(json['likedBy'] as List),
      comments: (json['comments'] as List)
          .map((c) => SocialComment.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Model representing a comment on a social activity
class SocialComment {
  /// Unique identifier for the comment
  final String id;

  /// User ID of the commenter
  final String userId;

  /// Content of the comment
  final String content;

  /// Creation timestamp
  final DateTime createdAt;

  /// Constructor for creating a social comment
  SocialComment({
    String? id,
    required this.userId,
    required this.content,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Convert social comment to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a social comment from a map (JSON deserialization)
  factory SocialComment.fromJson(Map<String, dynamic> json) {
    return SocialComment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
