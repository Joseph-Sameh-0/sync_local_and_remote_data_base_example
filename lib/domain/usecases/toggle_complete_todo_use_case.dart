
import '../repositories/todo_repository.dart';

class ToggleCompleteTodoUseCase {
  final TodoRepository repository;

  ToggleCompleteTodoUseCase({required this.repository});

  Future<void> call(String todoId, bool isCompleted) async {
    final todo = await repository.getTodoById(todoId);
    await repository.updateTodo(todo.copyWith(completed: !todo.completed));
    }
}