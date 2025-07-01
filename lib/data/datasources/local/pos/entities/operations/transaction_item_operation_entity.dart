import 'package:isar/isar.dart';

part 'transaction_item_operation_entity.g.dart';

@collection
class TransactionItemOperationEntity {
  Id id = Isar.autoIncrement;

  late String itemId;
  @enumerated
  late TransactionItemOperationType operationType;
  String? columnName;
  String? value;
  late DateTime timestamp;

  TransactionItemOperationEntity({
    required this.itemId,
    required this.operationType,
    this.columnName,
    this.value,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'TransactionItemOperationEntity(id: $id, itemId: $itemId, operationType: $operationType, columnName: $columnName, value: $value, timestamp: $timestamp)';
  }
}

enum TransactionItemOperationType {
  add,
  updateQuantity,
  updateSubtotal,
  remove,
}