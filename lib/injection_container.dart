import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/network_info_service/network_info_service.dart';
import 'core/services/network_info_service/network_info_service_connection_checker.dart';
import 'core/services/network_info_service/network_info_service_connectivity_plus.dart';
import 'core/services/firebase_service/firebase_service.dart';
import 'data/datasources/abstract/todo_data_source.dart';
import 'data/datasources/local/entities/todo_entity.dart';
import 'data/datasources/local/todo_local_data_source.dart';
import 'data/datasources/remote/dtos/todo_model.dart';
import 'core/services/firebase_service/firebase_service_impl.dart';
import 'data/datasources/remote/todo_remote_data_source.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/repositories/todo_repository.dart';
import 'domain/usecases/add_todo.dart';
import 'domain/usecases/get_all_todos_use_case.dart';
import 'domain/usecases/sync_use_case.dart';
import 'domain/usecases/toggle_complete_todo_use_case.dart';
import 'domain/usecases/watch_todos.dart';
import 'firebase_options.dart';
import 'presentation/cubit/connectivity_cubit.dart';
import 'presentation/cubit/todo_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  await _initializeFirebase();

  //! Core
  sl.registerLazySingleton<NetworkInfoService>(
    () => NetworkInfoServiceConnectionChecker(connectionChecker: sl()),
  );

  sl.registerLazySingleton<NetworkInfoService>(
    () => NetworkInfoServiceConnectivityPlus(connectivity: sl()),
  );

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<FirebaseService>(
    () => FirebaseServiceImpl(firestore: sl()),
  );

  //! Features - Todo
  // Cubit
  sl.registerFactory(
    () => TodoCubit(
      watchTodosUseCase: sl(),
      addTodoUseCase: sl(),
      toggleCompleteTodoUseCase: sl(),
      getAllTodosUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ConnectivityCubit(networkInfoService: sl(), syncUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => WatchTodosUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddTodoUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleCompleteTodoUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTodosUseCase(repository: sl()));
  sl.registerLazySingleton(() => SyncUseCase(todoRepository: sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfoService: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TodoDataSource<TodoDto>>(
    () => TodoFireStoreDataSource(firebaseService: sl()),
  );

  final appDir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([TodoEntitySchema], directory: appDir.path);

  sl.registerLazySingleton<Isar>(() => isar);

  sl.registerLazySingleton<TodoDataSource<TodoEntity>>(
    () => TodoIsarDataSource(db: sl()),
  );
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  } catch (e) {
    log('Failed to initialize Firebase: $e');
    rethrow;
  }
}
