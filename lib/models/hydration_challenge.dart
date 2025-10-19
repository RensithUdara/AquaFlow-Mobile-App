import 'package:uuid/uuid.dart';

/// Type of hydration challenge
enum ChallengeType {
  dailyGoal,
  streakGoal,
  totalAmount,
  consistencyGoal,
}

/// Status of the challenge
enum ChallengeStatus {
  upcoming,
  active,
  completed,
  failed,
  cancelled,
}

/// Model representing a hydration challenge
class HydrationChallenge {
  /// Unique identifier for the challenge
  final String id;

  /// Title of the challenge
  final String title;

  /// Description of the challenge
  final String description;

  /// Type of challenge
  final ChallengeType type;

  /// Creator of the challenge
  final String creatorId;

  /// List of participant user IDs
  final List<String> participantIds;

  /// Target value to achieve (e.g., days, amount in ml)
  final int targetValue;

  /// Start date of the challenge
  final DateTime startDate;

  /// End date of the challenge
  final DateTime endDate;

  /// Current status of the challenge
  final ChallengeStatus status;

  /// Map of participant IDs to their current progress
  final Map<String, int> progress;

  /// Constructor for creating a hydration challenge
  HydrationChallenge({
    String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.creatorId,
    required this.participantIds,
    required this.targetValue,
    required this.startDate,
    required this.endDate,
    this.status = ChallengeStatus.upcoming,
    Map<String, int>? progress,
  })  : id = id ?? const Uuid().v4(),
        progress = progress ?? {};

  /// Convert challenge to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'creatorId': creatorId,
      'participantIds': participantIds,
      'targetValue': targetValue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.index,
      'progress': progress,
    };
  }

  /// Create a challenge from a map (JSON deserialization)
  factory HydrationChallenge.fromJson(Map<String, dynamic> json) {
    return HydrationChallenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ChallengeType.values[json['type'] as int],
      creatorId: json['creatorId'] as String,
      participantIds: List<String>.from(json['participantIds'] as List),
      targetValue: json['targetValue'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: ChallengeStatus.values[json['status'] as int],
      progress: Map<String, int>.from(json['progress'] as Map),
    );
  }

  /// Create a copy of this challenge with specified fields replaced with new values
  HydrationChallenge copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    String? creatorId,
    List<String>? participantIds,
    int? targetValue,
    DateTime? startDate,
    DateTime? endDate,
    ChallengeStatus? status,
    Map<String, int>? progress,
  }) {
    return HydrationChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      creatorId: creatorId ?? this.creatorId,
      participantIds: participantIds ?? this.participantIds,
      targetValue: targetValue ?? this.targetValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  /// Check if the challenge is active based on dates
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Get duration of the challenge in days
  int get durationDays =>
      endDate.difference(startDate).inDays + 1; // +1 to include end date

  /// Get remaining days in the challenge
  int get remainingDays {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    if (now.isBefore(startDate)) return durationDays;
    return endDate.difference(now).inDays + 1;
  }

  /// Get progress percentage for a specific participant
  double getProgressPercentage(String userId) {
    final currentProgress = progress[userId] ?? 0;
    return (currentProgress / targetValue).clamp(0.0, 1.0);
  }

  /// Update progress for a participant
  void updateProgress(String userId, int newValue) {
    progress[userId] = newValue;
  }
}
