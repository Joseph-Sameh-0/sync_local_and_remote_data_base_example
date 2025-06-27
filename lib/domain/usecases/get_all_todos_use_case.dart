import '../entities/todo.dart';
import '../repositories/todo_repository.dart';
import 'base_use_case.dart';

class GetAllTodosUseCase implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;

  GetAllTodosUseCase({required this.repository});

  @override
  Future<List<Todo>> call(NoParams params) {
    return repository.getAllTodos();
  }
}
