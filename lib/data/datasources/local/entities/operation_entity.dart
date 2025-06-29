import 'package:isar/isar.dart';

part 'operation_entity.g.dart';

@collection
class OperationEntity {
  Id id = Isar.autoIncrement;

  late String itemId;
  late Operation operationType;
  late DateTime timestamp;
}

@embedded
class Operation{
  Operation();
  @enumerated
  late OperationType operationType;
  late String collectionName;
  late String columnName;
  String? get value => null;
}

enum OperationType {
  add,
  update,
  delete,
  increment,
  decrement,
}