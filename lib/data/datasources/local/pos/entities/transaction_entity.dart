import 'package:isar/isar.dart';

import '../../../../../domain/entities/pos.dart';
import '../../../remote/pos/dtos/transaction_dto.dart';

part 'transaction_entity.g.dart';

@collection
class TransactionEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String transactionId;
  late DateTime createdAt;
  late double total;
  late DateTime lastUpdate;

  TransactionEntity({
    required this.transactionId,
    required this.createdAt,
    required this.total,
    required this.lastUpdate,
  });

  factory TransactionEntity.fromDomain(Transaction transaction) {
    return TransactionEntity(
      transactionId: transaction.id,
      createdAt: transaction.createdAt,
      total: transaction.total,
      lastUpdate: transaction.lastUpdate,
    );
  }

  Transaction toDomain() {
    return Transaction(
      id: transactionId,
      createdAt: createdAt,
      total: total,
      lastUpdate: lastUpdate,
      items: []
    );
  }

  factory TransactionEntity.fromDto(TransactionDto transactionDto) {
    return TransactionEntity(
      transactionId: transactionDto.transactionId,
      createdAt: transactionDto.createdAt,
      total: transactionDto.total,
      lastUpdate: transactionDto.lastUpdate,
    );
  }

  @override
  String toString() {
    return 'TransactionEntity{transactionId: $transactionId, createdAt: $createdAt, total: $total, lastUpdate: $lastUpdate}';
  }
}

