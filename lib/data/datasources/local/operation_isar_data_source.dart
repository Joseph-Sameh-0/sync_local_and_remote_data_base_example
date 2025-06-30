import 'dart:convert';

import 'package:isar/isar.dart';

import '../../../domain/entities/transaction.dart';
import 'entities/transaction_operation_entity.dart';

abstract class TransactionOperationDataSource {
  Future<void> addTransaction(Transaction operation);

  Future<void> updateTransactionTitle(String id, String newTitle);

  Future<void> updateTransactionAmount(String id, int deltaAmount);

  Future<void> deleteTransaction(String id);

  Future<void> deleteOperation(Id id);

  Future<List<TransactionOperationEntity>> getAllOperations();
}

class TransactionOperationIsarDataSource implements TransactionOperationDataSource {
  final Isar db;

  TransactionOperationIsarDataSource({required this.db});

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.put(
        TransactionOperationEntity(
          itemId: transaction.id,
          operationType: TransactionOperationType.add,
          entity: jsonEncode(transaction.toJson()),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateTransactionTitle(String id, String newTitle) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.put(
        TransactionOperationEntity(
          itemId: id,
          operationType: TransactionOperationType.updateTitle,
          value: newTitle,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateTransactionAmount(String id, int deltaAmount) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.put(
        TransactionOperationEntity(
          itemId: id,
          operationType: TransactionOperationType.updateTitle,
          value: deltaAmount.toString(),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.put(
        TransactionOperationEntity(
          itemId: id,
          operationType: TransactionOperationType.delete,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<List<TransactionOperationEntity>> getAllOperations() async {
    return await db.transactionOperationEntitys.where().findAll();
  }

  @override
  Future<void> deleteOperation(Id id) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.delete(id);
    });
  }
}
