import '../../entities/pos.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> getTransactions();

  Future<String> addTransaction(Transaction transaction);

  Future<void> deleteTransaction(String transactionId);

  Future<Transaction> getTransactionById(String transactionId);

  Future<void> addTransactionItem({required TransactionItem transactionItem});

  Future<void> sync();
  void dispose();

  Future<List<PendingUpdates>> getPendingTransactions();
}

