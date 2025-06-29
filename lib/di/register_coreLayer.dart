import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../core/services/firebase_service/firebase_service.dart';
import '../core/services/firebase_service/firebase_service_impl.dart';
import '../core/services/network_info_service/network_info_service.dart';
// import '../core/services/network_info_service/network_info_service_connection_checker.dart';
import '../core/services/network_info_service/network_info_service_connectivity_plus.dart';
import 'injection_container.dart';

void registerCoreLayer() {
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // sl.registerLazySingleton<NetworkInfoService>(
  //       () => NetworkInfoServiceConnectionChecker(connectionChecker: sl()),
  // );

  sl.registerLazySingleton<NetworkInfoService>(
    () => NetworkInfoServiceConnectivityPlus(connectivity: sl()),
  );

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<FirebaseService>(
    () => FirebaseServiceImpl(firestore: sl()),
  );
}
