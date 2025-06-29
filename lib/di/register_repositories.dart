import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/todo_repository.dart';
import 'injection_container.dart';

void registerRepositories() {
  sl.registerLazySingleton<TodoRepository>(
        () => TodoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfoService: sl(),
      operationDataSource: sl(),
    ),
  );
}

