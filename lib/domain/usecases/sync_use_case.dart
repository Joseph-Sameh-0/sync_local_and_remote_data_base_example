
import '../repositories/pos/product_repository.dart';
import '../repositories/pos/transaction_repository.dart';
import 'base_use_case.dart';

class SyncUseCase extends UseCase<void, NoParams> {
  final TransactionRepository transactionRepository;
  final ProductRepository productRepository;

  SyncUseCase({
    required this.productRepository,
    required this.transactionRepository,
  });

  @override
  Future<void> call(NoParams cartItems) async {
    await transactionRepository.sync();
    await productRepository.sync();
  }
}
