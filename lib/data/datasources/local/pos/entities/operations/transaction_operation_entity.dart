import 'package:isar/isar.dart';

part 'transaction_operation_entity.g.dart';

@collection
class TransactionOperationEntity {
  Id id = Isar.autoIncrement;

  late String transactionId;
  @enumerated
  late TransactionOperationType operationType;
  String? columnName;
  String? value;
  late DateTime timestamp;

  TransactionOperationEntity({
    required this.transactionId,
    required this.operationType,
    this.columnName,
    this.value,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'TransactionOperationEntity(id: $id, transactionId: $transactionId, operationType: $operationType, columnName: $columnName, value: $value, timestamp: $timestamp)';
  }
}

enum TransactionOperationType {
  add,
  updateTotal,
  delete,
}