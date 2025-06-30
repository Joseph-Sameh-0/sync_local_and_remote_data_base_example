import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/transaction_repository.dart';
import 'injection_container.dart';

void registerRepositories() {
  sl.registerLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfoService: sl(),
      operationDataSource: sl(),
    ),
  );
}

