class Transaction {
  final String id;
  final String title;
  final int amount;
  final DateTime createdAt;
  final DateTime lastUpdate;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
    required this.lastUpdate,
  });

  Transaction copyWith({
    String? id,
    String? title,
    int? amount,
    DateTime? createdAt,
    DateTime? lastUpdate,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  @override
  String toString() {
    return 'Transaction{id: $id, title: $title, amount: $amount, createdAt: $createdAt}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: json['amount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );
  }
}
