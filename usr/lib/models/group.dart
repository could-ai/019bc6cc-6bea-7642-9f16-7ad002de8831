class Group {
  final String id;
  final String name;
  final String currency;
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.currency,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currency': currency,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      currency: map['currency'],
      memberIds: List<String>.from(map['memberIds']),
      createdBy: map['createdBy'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}