import '../../models/todo_model.dart';

abstract class TodoDataSource {
  Stream<List<TodoModel>> watchTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
  Future<TodoModel> getTodoById(String todoId);
  Future<List<TodoModel>> getAllTodos();
  Future<void> batchUpdateTodos(List<TodoModel> todos);
}