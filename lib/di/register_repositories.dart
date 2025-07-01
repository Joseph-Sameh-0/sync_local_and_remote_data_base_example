
import '../data/repositories/pos/product_repository_impl.dart';
import '../data/repositories/pos/transaction_repository_impl.dart';
import '../domain/repositories/pos/product_repository.dart';
import '../domain/repositories/pos/transaction_repository.dart';
import 'injection_container.dart';

void registerRepositories() {
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfoService: sl(),
      transactionOperationDataSource: sl(),
      transactionItemOperationDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      productOperationDataSource: sl(),
      networkInfoService: sl(),
    ),
  );
}
