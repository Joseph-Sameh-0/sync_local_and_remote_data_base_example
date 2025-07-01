import '../../../../core/services/firebase_service/firebase_service.dart';
import '../../utils/write_operation.dart';
import 'dtos/transaction_dto.dart';

abstract class TransactionRemoteDataSource {
  Stream<List<TransactionDto>> watchTransactions();

  Future<void> addTransaction(TransactionDto transaction);

  Future<void> updateTransaction(TransactionDto transaction);

  Future<void> deleteTransaction(String id);

  Future<TransactionDto?> getTransactionById(String transactionId);

  Future<List<TransactionDto>> getAllTransactions();

  Future<void> batchUpdateTransactions(List<TransactionDto> transactions);
}

class TransactionFireStoreDataSource implements TransactionRemoteDataSource {
  final FirebaseService firebaseService;
  final String transactionsPath = 'transactions';

  TransactionFireStoreDataSource({required this.firebaseService});

  @override
  Stream<List<TransactionDto>> watchTransactions() {
    return firebaseService.streamCollection<TransactionDto>(
      path: transactionsPath,
      fromJson: TransactionDto.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<void> addTransaction(TransactionDto transaction) async {
    await firebaseService.addToCollection(path: transactionsPath, data: transaction.toJson());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await firebaseService.deleteDoc(path: '$transactionsPath/$id');
  }

  @override
  Future<void> updateTransaction(TransactionDto transaction) async {
    await firebaseService.updateDoc(
      path: '$transactionsPath/${transaction.id}',
      data: transaction.toJson(),
    );
  }

  @override
  Future<TransactionDto?> getTransactionById(String transactionId) async {
    return await firebaseService.getDoc<TransactionDto>(
      path: '$transactionsPath/$transactionId',
      fromJson: TransactionDto.fromJson,
    );
  }

  @override
  Future<List<TransactionDto>> getAllTransactions() async {
    return await firebaseService.getCollection<TransactionDto>(
      path: transactionsPath,
      fromJson: TransactionDto.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<void> batchUpdateTransactions(List<TransactionDto> transactions) async {
    final operations = transactions
        .map(
          (transaction) =>
              WriteOperation.update('$transactionsPath/${transaction.id}', transaction.toJson()),
        )
        .toList();

    await firebaseService.batchWrite(operations);
  }
}
