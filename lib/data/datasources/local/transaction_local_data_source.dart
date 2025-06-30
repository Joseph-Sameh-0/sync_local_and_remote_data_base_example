import 'package:isar/isar.dart';

import '../../../domain/Exception/exceptions.dart';
import 'entities/transaction_entity.dart';

abstract class TransactionLocalDataSource {
  Stream<List<TransactionEntity>> watchTransactions();

  Future<void> addTransaction(TransactionEntity transaction);

  Future<void> updateTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction(String id);

  Future<TransactionEntity?> getTransactionById(String transactionId);

  Future<List<TransactionEntity>> getAllTransactions();

  Future<void> batchUpdateTransactions(List<TransactionEntity> transactions);

  Future<void> overrideTransactions(List<TransactionEntity> transactions);
}


class TransactionIsarDataSource implements TransactionLocalDataSource {
  final Isar db;

  TransactionIsarDataSource({required this.db});

  @override
  Stream<List<TransactionEntity>> watchTransactions() async* {
    yield* db.transactionEntitys.where().watch(fireImmediately: true);
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
        .idEqualTo(transaction.id)
        .findFirst();
    if (existingTransaction != null) {
      try {
        await db.writeTxn(() async {
          await db.transactionEntitys.put(transaction..isarId = existingTransaction.isarId);
        });
      } catch (e) {
        throw TransactionNotUpdatedException();
      }
    } else {
      throw TransactionDoesNotFoundException();
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final transaction = await db.transactionEntitys.where().idEqualTo(id).findFirst();
    if (transaction != null) {
      await db.writeTxn(() async {
        await db.transactionEntitys.delete(transaction.isarId);
      });
    }
  }

  @override
  Future<void> batchUpdateTransactions(List<TransactionEntity> transactions) async {
    final ids = transactions.map((e) => e.id).toList();
    final existing = await db.transactionEntitys
        .where()
        .anyOf(ids, (q, id) => q.idEqualTo(id))
        .findAll();

    final transactionsWithIsarId = transactions.map((transaction) {
      final match = existing.firstWhere(
        (e) => e.id == transaction.id,
        orElse: () => transaction,
      );
      return transaction..isarId = match.isarId;
    }).toList();

    await db.writeTxn(() async {
      await db.transactionEntitys.putAll(transactionsWithIsarId);
    });
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() {
    return db.transactionEntitys.where().findAll();
  }

  @override
  Future<TransactionEntity?> getTransactionById(String transactionId) async {
    return db.transactionEntitys.where().idEqualTo(transactionId).findFirst();
  }

  @override
  Future<void> overrideTransactions(List<TransactionEntity> transactions) async {
    await db.writeTxn(() async {
      await db.transactionEntitys.clear();
      await db.transactionEntitys.putAll(transactions);
    });
  }
}
