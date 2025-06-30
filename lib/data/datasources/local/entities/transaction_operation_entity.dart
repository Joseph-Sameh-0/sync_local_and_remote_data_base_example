import 'package:isar/isar.dart';

part 'transaction_operation_entity.g.dart';

@collection
class TransactionOperationEntity {
  Id id = Isar.autoIncrement;

  late String itemId;
  @enumerated
  late TransactionOperationType operationType;
  String? columnName;
  String? value;
  String? entity;
  late DateTime timestamp;

  TransactionOperationEntity({
    required this.itemId,
    required this.operationType,
    this.columnName,
    this.value,
    this.entity,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'TransactionOperationEntity(id: $id, itemId: $itemId, operationType: $operationType, columnName: $columnName, value: $value, entity: $entity, timestamp: $timestamp)';
  }
}

enum TransactionOperationType {
  add,
  updateTitle,
  updateAmount,
  delete,
}