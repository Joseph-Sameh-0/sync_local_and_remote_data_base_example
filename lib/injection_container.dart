import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/abstract/firebase_service.dart';
import 'data/datasources/abstract/network_info.dart';
import 'data/datasources/abstract/todo_data_source.dart';
import 'domain/usecases/get_all_todos_use_case.dart';
import 'domain/usecases/toggle_complete_todo_use_case.dart';
import 'firebase_options.dart';
import 'data/datasources/remote/firebase_service_impl.dart';
import 'data/datasources/remote/network_info_remote.dart';
import 'data/datasources/remote/todo_remote_data_source.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/repositories/todo_repository.dart';
import 'domain/usecases/add_todo.dart';
import 'domain/usecases/watch_todos.dart';
import 'presentation/cubit/todo_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  await _initializeFirebase();

  //! Core
  sl.registerLazySingleton<NetworkInfoDataSource>(
    () => NetworkInfoRemoteDataSource(connectionChecker: sl()),
  );
  sl.registerLazySingleton<FirebaseService>(() => FirebaseServiceImpl(firestore: sl()));

  //! Features - Auth
  // Bloc
  // sl.registerFactory(() => AuthBloc(loginUser: sl()));

  //! Features - Todo
  // Cubit
  sl.registerFactory(() => TodoCubit(watchTodosUseCase: sl(), addTodoUseCase: sl(), toggleCompleteTodoUseCase: sl(), getAllTodosUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => WatchTodosUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddTodoUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleCompleteTodoUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTodosUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(remoteDataSource: sl()),
  );


  // Data sources
  sl.registerLazySingleton<TodoDataSource>(
    () => TodoFireStoreDataSource(firebaseService: sl()),
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
