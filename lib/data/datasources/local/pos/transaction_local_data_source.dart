import 'package:isar/isar.dart';

import '../../../../domain/Exception/exception_tree.dart';
import 'entities/transaction_entity.dart';
import 'entities/transaction_item_entity.dart';

abstract class TransactionLocalDataSource {
  Stream<List<TransactionEntity>> getTransactions();

  Future<TransactionEntity?> getTransactionById(String transactionId);

  Future<void> addTransaction(TransactionEntity transaction);

  Future<void> updateTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction(String transactionId);

  Future<void> overrideTransactions(List<TransactionEntity> transactions);

  Stream<List<TransactionItemEntity>> getTransactionItems(String transactionId);

  Future<void> addTransactionItem(TransactionItemEntity item);

  Future<void> updateTransactionItem(TransactionItemEntity item);

  Future<void> deleteTransactionItem(String itemId);

  Future<void> overrideTransactionItems(List<TransactionItemEntity> items);
}

class TransactionIsarDataSource implements TransactionLocalDataSource {
  final Isar db;

  TransactionIsarDataSource({required this.db});

  @override
  Stream<List<TransactionEntity>> getTransactions() async* {
    yield* db.transactionEntitys.where().watch(fireImmediately: true);
  }

  @override
  Future<TransactionEntity?> getTransactionById(String transactionId) async {
    return await db.transactionEntitys
        .where()
        .transactionIdEqualTo(transactionId)
        .findFirst();
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    await db.writeTxn(() async {
      await db.transactionEntitys.put(transaction);
    });
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final existingTransaction = await db.transactionEntitys
        .where()
        .transactionIdEqualTo(transaction.transactionId)
        .findFirst();
    if (existingTransaction != null) {
      try {
        await db.writeTxn(() async {
          await db.transactionEntitys.put(
            transaction..isarId = existingTransaction.isarId,
          );
        });
      } catch (e) {
        throw AppExceptions.dataExceptions.updateTransactionEntityException;
      }
    } else {
      throw AppExceptions.dataExceptions.transactionEntityNotFoundException;
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await db.writeTxn(() async {
      final transaction = await getTransactionById(transactionId);
      if (transaction != null) {
        await db.transactionEntitys.delete(transaction.isarId);
      }
    });
  }

  @override
  Future<void> overrideTransactions(
    List<TransactionEntity> transactions,
  ) async {
    await db.writeTxn(() async {
      await db.transactionEntitys.clear();
      await db.transactionEntitys.putAll(transactions);
    });
  }

  @override
  Future<void> addTransactionItem(TransactionItemEntity item) {
    return db.writeTxn(() async {
      await db.transactionItemEntitys.put(item);
    });
  }

  @override
  Future<void> deleteTransactionItem(String itemId) {
    return db.writeTxn(() async {
      final item = await db.transactionItemEntitys
          .where()
          .itemIdEqualTo(itemId)
          .findFirst();
      if (item != null) {
        await db.transactionItemEntitys.delete(item.isarId);
      } else {
        throw AppExceptions.dataExceptions.transactionItemNotFoundException;
      }
    });
  }

  @override
  Stream<List<TransactionItemEntity>> getTransactionItems(
    String transactionId,
  ) {
    return db.transactionItemEntitys
        .where()
        .transactionIdEqualTo(transactionId)
        .watch(fireImmediately: true);
  }

  @override
  Future<void> overrideTransactionItems(List<TransactionItemEntity> items) {
    return db.writeTxn(() async {
      await db.transactionItemEntitys.clear();
      await db.transactionItemEntitys.putAll(items);
    });
  }

  @override
  Future<void> updateTransactionItem(TransactionItemEntity item) {
    return db.writeTxn(() async {
      final existingItem = await db.transactionItemEntitys
          .where()
          .itemIdEqualTo(item.itemId)
          .findFirst();
      if (existingItem != null) {
        await db.transactionItemEntitys.put(item..isarId = existingItem.isarId);
      } else {
        throw AppExceptions.dataExceptions.transactionItemNotFoundException;
      }
    });
  }
}
