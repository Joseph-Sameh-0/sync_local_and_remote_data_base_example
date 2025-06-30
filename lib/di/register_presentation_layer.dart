import '../presentation/cubit/connectivity_cubit.dart';
import '../presentation/cubit/transaction_cubit.dart';
import 'injection_container.dart';

void registerPresentationLayer() {
  sl.registerFactory(
        () => TransactionCubit(
      watchTransactionsUseCase: sl(),
      addTransactionUseCase: sl(),
      getAllTransactionsUseCase: sl(),
    ),
  );
  sl.registerFactory(
        () => ConnectivityCubit(networkInfoService: sl(), syncUseCase: sl()),
  );
}
