import '../entities/pos.dart';
import '../repositories/pos/transaction_repository.dart';
import 'base_use_case.dart';

class GetTransactionsUseCase extends StreamUseCase<List<Transaction>, NoParams> {
  final TransactionRepository transactionRepository;

  GetTransactionsUseCase({required this.transactionRepository});

  @override
  Stream<List<Transaction>> call(NoParams params) {
    return transactionRepository.getTransactions();
  }
}

class GetPendingTransactionsUseCase extends UseCase<List<PendingTransaction>, NoParams>{
  final TransactionRepository transactionRepository;

  GetPendingTransactionsUseCase({required this.transactionRepository});

  @override
  Future<List<PendingTransaction>> call(NoParams params) {
    return transactionRepository.getPendingTransactions();
  }

}
