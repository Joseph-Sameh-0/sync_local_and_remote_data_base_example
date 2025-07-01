import 'package:sync_local_and_remote_data_base_example/domain/repositories/pos/product_repository.dart';

import '../entities/pos.dart';
import '../repositories/pos/transaction_repository.dart';
import 'base_use_case.dart';

class GetTransactionsUseCase
    extends StreamUseCase<List<Transaction>, NoParams> {
  final TransactionRepository transactionRepository;

  GetTransactionsUseCase({required this.transactionRepository});

  @override
  Stream<List<Transaction>> call(NoParams params) {
    return transactionRepository.getTransactions();
  }
}

class GetPendingUpdatesUseCase
    extends UseCase<List<PendingUpdates>, NoParams> {
  final TransactionRepository transactionRepository;
  final ProductRepository productRepository;

  GetPendingUpdatesUseCase({
    required this.transactionRepository,
    required this.productRepository,
  });

  @override
  Future<List<PendingUpdates>> call(NoParams params) async {
    final pendingTransactions = await transactionRepository.getPendingTransactions();
    final pendingProductUpdates = await productRepository.getPendingProductsUpdates();
    return [...pendingTransactions, ...pendingProductUpdates];
  }
}
