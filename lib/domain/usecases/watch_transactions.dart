import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'base_use_case.dart';

class WatchTransactionsUseCase implements StreamUseCase<List<Transaction>, NoParams> {
  final TransactionRepository repository;

  WatchTransactionsUseCase({required this.repository});

  @override
  Stream<List<Transaction>> call(NoParams params) {
    return repository.watchTransactions();
  }
}
