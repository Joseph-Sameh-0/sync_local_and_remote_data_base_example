import '../entities/todo.dart';
import '../repositories/todo_repository.dart';
import 'base_use_case.dart';

class AddTodoUseCase implements UseCase<void, Todo> {
  final TodoRepository repository;

  AddTodoUseCase({required this.repository});

  @override
  Future<void> call(Todo params) {
    return repository.addTodo(params);
  }
}