
import 'package:isar/isar.dart';

import '../local/entities/operation_entity.dart';

abstract class OperationDataSource {
  Future<void> addOperation(OperationEntity operation);
  Future<void> batchWriteOperations(List<OperationEntity> operations);
  Future<List<OperationEntity>> getAllOperations();
  Future<void> deleteOperation(Id id);
}