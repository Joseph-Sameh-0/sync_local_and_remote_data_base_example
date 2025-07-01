
import '../domain/usecases/pos_usecases.dart';
import '../domain/usecases/sync_use_case.dart';
import 'injection_container.dart';

void registerDomainLayer() {
  sl.registerLazySingleton(
    () => SyncUseCase(transactionRepository: sl(), productRepository: sl()),
  );
  sl.registerLazySingleton(() => GetProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase());
  sl.registerLazySingleton(
    () => ProcessSaleUseCase(
      productRepository: sl(),
      transactionRepository: sl(),
    ),
  );
  sl.registerLazySingleton(() => AddProductUseCase(productRepository: sl()));
}
