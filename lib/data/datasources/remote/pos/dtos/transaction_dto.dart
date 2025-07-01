import '../../../../../domain/entities/pos.dart';

class TransactionDto {
  final String transactionId;
  final double total;
  final DateTime createdAt;
  final DateTime lastUpdate;

  TransactionDto({
    required this.transactionId,
    required this.total,
    required this.createdAt,
    required this.lastUpdate,
  });

  static TransactionDto fromDomain(Transaction transaction) {
    return TransactionDto(
      transactionId: transaction.id,
      total: transaction.total,
      createdAt: transaction.createdAt,
      lastUpdate: transaction.lastUpdate,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }
  factory TransactionDto.fromJson(Map<String, dynamic> map, String id) {
    return TransactionDto(
      transactionId: id,
      total: map['total'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdate: DateTime.parse(map['lastUpdate'] as String),
    );
  }

  TransactionDto copyWith ({
    String? transactionId,
    double? total,
    DateTime? createdAt,
    DateTime? lastUpdate,
  }) {
    return TransactionDto(
      transactionId: transactionId ?? this.transactionId,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}