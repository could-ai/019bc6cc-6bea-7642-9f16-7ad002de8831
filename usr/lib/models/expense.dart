enum SplitType { equal, unequal, percentage, shares }

class Expense {
  final String id;
  final String groupId;
  final String description;
  final double amount;
  final String paidBy;
  final List<String> participants;
  final SplitType splitType;
  final Map<String, double> splits;
  final String? receiptImage;
  final DateTime createdAt;
  final bool isSettled;

  Expense({
    required this.id,
    required this.groupId,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.participants,
    required this.splitType,
    required this.splits,
    this.receiptImage,
    required this.createdAt,
    this.isSettled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'description': description,
      'amount': amount,
      'paidBy': paidBy,
      'participants': participants,
      'splitType': splitType.toString(),
      'splits': splits,
      'receiptImage': receiptImage,
      'createdAt': createdAt.toIso8601String(),
      'isSettled': isSettled,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      groupId: map['groupId'],
      description: map['description'],
      amount: map['amount'],
      paidBy: map['paidBy'],
      participants: List<String>.from(map['participants']),
      splitType: SplitType.values.firstWhere(
        (e) => e.toString() == map['splitType'],
      ),
      splits: Map<String, double>.from(map['splits']),
      receiptImage: map['receiptImage'],
      createdAt: DateTime.parse(map['createdAt']),
      isSettled: map['isSettled'] ?? false,
    );
  }
}