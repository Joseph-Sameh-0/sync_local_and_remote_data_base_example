import '../presentation/cubit/connectivity_cubit.dart';
import '../presentation/cubit/todo_cubit.dart';
import 'injection_container.dart';

void registerPresentationLayer() {
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
}
