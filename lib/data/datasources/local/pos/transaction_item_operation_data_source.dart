import 'dart:convert';

import 'package:isar/isar.dart';

import '../../../../domain/entities/pos.dart';
import 'entities/operations/transaction_item_operation_entity.dart';

abstract class TransactionItemOperationDataSource {
  Future<void> addItem(TransactionItem item);

  Future<void> updateItemQuantity(String itemId, int newQuantity);
  Future<void> updateItemSubtotal(String itemId, double newSubtotal);

  Future<void> removeItem(String itemId);

  Future<void> deleteOperation(Id id);

  Future<List<TransactionItemOperationEntity>> getAllOperations();
}

class TransactionItemOperationIsarDataSource
    implements TransactionItemOperationDataSource {
  final Isar db;

  TransactionItemOperationIsarDataSource({required this.db});

  @override
  Future<void> addItem(TransactionItem item) async {
    await db.writeTxn(() async {
      await db.transactionItemOperationEntitys.put(
        TransactionItemOperationEntity(
          itemId: item.itemId,
          operationType: TransactionItemOperationType.add,
          value: jsonEncode(item.toJson()),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    await db.writeTxn(() async {
      await db.transactionItemOperationEntitys.put(
        TransactionItemOperationEntity(
          itemId: itemId,
          operationType: TransactionItemOperationType.updateQuantity,
          value: newQuantity.toString(),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateItemSubtotal(String itemId, double newSubtotal) async {
    await db.writeTxn(() async {
      await db.transactionItemOperationEntitys.put(
        TransactionItemOperationEntity(
          itemId: itemId,
          operationType: TransactionItemOperationType.updateSubtotal,
          value: newSubtotal.toString(),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> removeItem(String itemId) async {
    await db.writeTxn(() async {
      await db.transactionItemOperationEntitys.put(
        TransactionItemOperationEntity(
          itemId: itemId,
          operationType: TransactionItemOperationType.remove,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<List<TransactionItemOperationEntity>> getAllOperations() async {
    return await db.transactionItemOperationEntitys.where().findAll();
  }

  @override
  Future<void> deleteOperation(Id id) async {
    await db.writeTxn(() async {
      await db.transactionItemOperationEntitys.delete(id);
    });
  }
}