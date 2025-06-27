import '../entities/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> watchTodos();
  Future<List<Todo>> getAllTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<Todo> getTodoById(String todoId);
}