import '../domain/usecases/add_transaction.dart';
import '../domain/usecases/get_all_transactions_use_case.dart';
import '../domain/usecases/sync_use_case.dart';
import '../domain/usecases/watch_transactions.dart';
import 'injection_container.dart';

void registerDomainLayer() {
  sl.registerLazySingleton(() => WatchTransactionsUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddTransactionUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTransactionsUseCase(repository: sl()));
  sl.registerLazySingleton(() => SyncUseCase(transactionRepository: sl()));
}
