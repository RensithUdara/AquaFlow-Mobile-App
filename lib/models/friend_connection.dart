/// Status of a friend request
enum FriendRequestStatus {
  pending,
  accepted,
  declined,
}

/// Model representing a connection between users
class FriendConnection {
  /// ID of the user who sent the request
  final String requesterId;

  /// ID of the user who received the request
  final String receiverId;

  /// Status of the friend request
  final FriendRequestStatus status;

  /// When the request was sent
  final DateTime requestedAt;

  /// When the request was responded to
  final DateTime? respondedAt;

  /// Constructor for creating a friend connection
  FriendConnection({
    required this.requesterId,
    required this.receiverId,
    required this.status,
    required this.requestedAt,
    this.respondedAt,
  });

  /// Convert friend connection to a map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'requesterId': requesterId,
      'receiverId': receiverId,
      'status': status.index,
      'requestedAt': requestedAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  /// Create a friend connection from a map (JSON deserialization)
  factory FriendConnection.fromJson(Map<String, dynamic> json) {
    return FriendConnection(
      requesterId: json['requesterId'] as String,
      receiverId: json['receiverId'] as String,
      status: FriendRequestStatus.values[json['status'] as int],
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
    );
  }

  /// Create a copy of this connection with specified fields replaced with new values
  FriendConnection copyWith({
    String? requesterId,
    String? receiverId,
    FriendRequestStatus? status,
    DateTime? requestedAt,
    DateTime? respondedAt,
  }) {
    return FriendConnection(
      requesterId: requesterId ?? this.requesterId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}
