import '../../../../domain/entities/transaction.dart';

class TransactionDto {
  final String id;
  final String title;
  final int amount;
  final DateTime createdAt;
  final DateTime lastUpdate;

  TransactionDto({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
    required this.lastUpdate,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json, String id) {
    return TransactionDto(
      id: id,
      title: json['title'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdate: DateTime.parse(json['lastUpdate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory TransactionDto.fromDomain(Transaction todo) {
    return TransactionDto(
      id: todo.id,
      title: todo.title,
      amount: todo.amount,
      createdAt: todo.createdAt,
      lastUpdate: todo.lastUpdate,
    );
  }

  TransactionDto copyWith({
    String? id,
    String? title,
    int? amount,
    DateTime? createdAt,
    DateTime? lastUpdate,
  }) {
    return TransactionDto(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, createdAt: $createdAt, lastUpdate: $lastUpdate)';
  }
}
