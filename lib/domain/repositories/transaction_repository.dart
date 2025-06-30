import '../entities/transaction.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> watchTransactions();
  Future<List<Transaction>> getAllTransactions();
  Future<void> addTransaction(Transaction todo);
  Future<void> updateTransactionTitle(Transaction updatedTransaction, String newTitle);
  Future<void> updateTransactionAmount(Transaction updatedTransaction, int deltaAmount);
  Future<void> deleteTransaction(String id);
  Future<Transaction> getTransactionById(String todoId);
  void dispose();
  Future<void> syncTransactions();
}