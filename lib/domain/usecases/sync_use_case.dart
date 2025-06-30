import '../repositories/transaction_repository.dart';
import 'base_use_case.dart';

class SyncUseCase extends UseCase<void, NoParams> {
  final TransactionRepository transactionRepository;

  SyncUseCase({required this.transactionRepository});

  @override
  Future<void> call(NoParams params) async {
    await transactionRepository.syncTransactions();
  }
}
