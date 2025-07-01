import '../presentation/cubit/pos_cubit.dart';

import '../presentation/cubit/connectivity_cubit.dart';
import 'injection_container.dart';

void registerPresentationLayer() {
  sl.registerFactory(
    () => ConnectivityCubit(networkInfoService: sl(), syncUseCase: sl()),
  );
  sl.registerFactory(
    () => POSCubit(
      getProducts: sl(),
      processSale: sl(),
      searchProductsUseCase: sl(),
      addProductUseCase: sl(),
    ),
  );
}
