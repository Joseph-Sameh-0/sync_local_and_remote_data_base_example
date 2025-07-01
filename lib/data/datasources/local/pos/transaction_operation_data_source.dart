
import 'dart:convert';

import 'package:isar/isar.dart';

import '../../../../domain/entities/pos.dart';
import 'entities/operations/transaction_operation_entity.dart';

abstract class TransactionOperationDataSource {
  Future<void> addTransaction(Transaction transaction);

  Future<void> updateTransactionTotal(String id, double newTotal);

  Future<void> deleteTransaction(String id);

  Future<void> deleteOperation(Id id);

  Future<List<TransactionOperationEntity>> getAllOperations();
  Future<List<TransactionOperationEntity>> getOperationsByTransactionId(String transactionId);
}

class TransactionOperationIsarDataSource implements TransactionOperationDataSource {
  final Isar db;

  TransactionOperationIsarDataSource({required this.db});

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.put(
        TransactionOperationEntity(
          transactionId: transaction.id,
          operationType: TransactionOperationType.add,
          value: jsonEncode(transaction.toJson()),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateTransactionTotal(String id, double newTotal) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.put(
        TransactionOperationEntity(
          transactionId: id,
          operationType: TransactionOperationType.updateTotal,
          value: newTotal.toString(),
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
          transactionId: id,
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
  Future<List<TransactionOperationEntity>> getOperationsByTransactionId(String transactionId) async {
    return await db.transactionOperationEntitys
        .where()
        .filter()
        .transactionIdEqualTo(transactionId)
        .findAll();
  }

  @override
  Future<void> deleteOperation(Id id) async {
    await db.writeTxn(() async {
      await db.transactionOperationEntitys.delete(id);
    });
  }
}