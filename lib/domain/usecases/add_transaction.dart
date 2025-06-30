import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'base_use_case.dart';

class AddTransactionUseCase implements UseCase<void, Transaction> {
  final TransactionRepository repository;

  AddTransactionUseCase({required this.repository});

  @override
  Future<void> call(Transaction params) {
    return repository.addTransaction(params);
  }
}