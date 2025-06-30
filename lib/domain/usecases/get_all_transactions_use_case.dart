import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'base_use_case.dart';

class GetAllTransactionsUseCase implements UseCase<List<Transaction>, NoParams> {
  final TransactionRepository repository;

  GetAllTransactionsUseCase({required this.repository});

  @override
  Future<List<Transaction>> call(NoParams params) {
    return repository.getAllTransactions();
  }
}
