import 'package:isar/isar.dart';

import '../abstract/operation_data_source.dart';
import 'entities/operation_entity.dart';

class OperationIsarDataSource implements OperationDataSource {
  final Isar db;

  OperationIsarDataSource({required this.db});

  @override
  Future<void> addOperation(OperationEntity operation) async {
    await db.writeTxn(() async {
      await db.operationEntitys.put(operation);
    });
  }

  @override
  Future<List<OperationEntity>> getAllOperations() async {
    return db.operationEntitys.where().findAll();
  }

  @override
  Future<void> deleteOperation(Id id) async {
    await db.writeTxn(() async {
      await db.operationEntitys.delete(id);
    });
  }

  @override
  Future<void> batchWriteOperations(List<OperationEntity> operations) {
    return db.writeTxn(() async {
      await db.operationEntitys.putAll(operations);
    });
  }
}