import '../domain/usecases/add_todo.dart';
import '../domain/usecases/get_all_todos_use_case.dart';
import '../domain/usecases/sync_use_case.dart';
import '../domain/usecases/toggle_complete_todo_use_case.dart';
import '../domain/usecases/watch_todos.dart';
import 'injection_container.dart';

void registerDomainLayer() {
  sl.registerLazySingleton(() => WatchTodosUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddTodoUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleCompleteTodoUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTodosUseCase(repository: sl()));
  sl.registerLazySingleton(() => SyncUseCase(todoRepository: sl()));
}
