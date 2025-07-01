import '../presentation/cubit/pos_cubit.dart';

import '../presentation/cubit/connectivity_cubit.dart';
import '../presentation/cubit/transactions_cubit.dart';
import 'injection_container.dart';

void registerPresentationLayer() {
  sl.registerFactory(
    () => POSCubit(
      getProducts: sl(),
      processSale: sl(),
      searchProductsUseCase: sl(),
      addProductUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => TransactionsCubit(
      getTransactionsUseCase: sl(),
      getPendingTransactionsUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => ConnectivityCubit(networkInfoService: sl(), syncUseCase: sl()),
  );
}
