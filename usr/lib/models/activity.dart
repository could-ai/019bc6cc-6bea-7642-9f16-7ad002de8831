class Activity {
  final String id;
  final String groupId;
  final String userId;
  final String type; // 'expense_added', 'settlement', 'group_created', etc.
  final String message;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  Activity({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.type,
    required this.message,
    required this.createdAt,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'userId': userId,
      'type': type,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      groupId: map['groupId'],
      userId: map['userId'],
      type: map['type'],
      message: map['message'],
      createdAt: DateTime.parse(map['createdAt']),
      metadata: map['metadata'],
    );
  }
}