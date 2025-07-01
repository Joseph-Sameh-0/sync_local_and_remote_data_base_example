import '../../../../core/services/firebase_service/firebase_service.dart';
import 'dtos/transaction_dto.dart';
import 'dtos/transaction_item_dto.dart';

abstract class TransactionRemoteDataSource {
  Stream<List<TransactionDto>> getTransactions();

  Future<TransactionDto?> getTransactionById(String transactionId);

  Future<String> addTransaction(TransactionDto transaction);

  Future<void> updateTransaction(TransactionDto transaction);

  Future<void> deleteTransaction(String transactionId);

  Stream<List<TransactionItemDto>> getTransactionItems(String transactionId);

  Future<void> addTransactionItem(TransactionItemDto item);

  Future<void> updateTransactionItem(TransactionItemDto item);

  Future<void> deleteTransactionItem(String itemId);

  Future getTransactionItemById(String itemId);
}

class TransactionFireStoreDataSource implements TransactionRemoteDataSource {
  final FirebaseService firebaseService;
  final String transactionsPath = 'transactions';
  final String transactionItemsPath = 'transaction_items';

  TransactionFireStoreDataSource({required this.firebaseService});

  @override
  Stream<List<TransactionDto>> getTransactions() {
    return firebaseService.streamCollection<TransactionDto>(
      path: transactionsPath,
      fromJson: TransactionDto.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<String> addTransaction(TransactionDto transaction) async {
    return await firebaseService.addToCollection(
      path: transactionsPath,
      data: transaction.toJson(),
    );
  }

  @override
  Future<void> addTransactionItem(TransactionItemDto item) {
    return firebaseService.addToCollection(
      path: transactionItemsPath,
      data: item.toJson(),
    );
  }

  @override
  Future<void> deleteTransaction(String transactionId) {
    return firebaseService.deleteDoc(path: '$transactionsPath/$transactionId');
  }

  @override
  Future<void> deleteTransactionItem(String itemId) {
    return firebaseService.deleteDoc(path: '$transactionItemsPath/$itemId');
  }

  @override
  Future<TransactionDto?> getTransactionById(String transactionId) {
    return firebaseService.getDoc<TransactionDto>(
      path: '$transactionsPath/$transactionId',
      fromJson: TransactionDto.fromJson,
    );
  }

  @override
  Stream<List<TransactionItemDto>> getTransactionItems(String transactionId) {
    return firebaseService.streamCollection<TransactionItemDto>(
      path: transactionItemsPath,
      fromJson: TransactionItemDto.fromJson,
      queryBuilder: (query) =>
          query.where('transactionId', isEqualTo: transactionId),
    );
  }

  @override
  Future<void> updateTransaction(TransactionDto transaction) {
    return firebaseService.updateDoc(
      path: '$transactionsPath/${transaction.transactionId}',
      data: transaction.toJson(),
    );
  }

  @override
  Future<void> updateTransactionItem(TransactionItemDto item) {
    return firebaseService.updateDoc(
      path: '$transactionItemsPath/${item.itemId}',
      data: item.toJson(),
    );
  }

  @override
  Future getTransactionItemById(String itemId) {
    return firebaseService.getDoc<TransactionItemDto>(
      path: '$transactionItemsPath/$itemId',
      fromJson: TransactionItemDto.fromJson,
    );
  }
}
