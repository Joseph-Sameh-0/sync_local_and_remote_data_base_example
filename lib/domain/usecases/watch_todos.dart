import '../entities/todo.dart';
import '../repositories/todo_repository.dart';
import 'base_use_case.dart';

class WatchTodosUseCase implements StreamUseCase<List<Todo>, NoParams> {
  final TodoRepository repository;

  WatchTodosUseCase({required this.repository});

  @override
  Stream<List<Todo>> call(NoParams params) {
    return repository.watchTodos();
  }
}
