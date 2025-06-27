import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/abstract/todo_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource remoteDataSource;

  TodoRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Todo>> watchTodos() {
    return remoteDataSource.watchTodos().map((models) {
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    final todoModels = await remoteDataSource.getAllTodos();
    return todoModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await remoteDataSource.addTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<void> deleteTodo(String id) {
    return remoteDataSource.deleteTodo(id);
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return remoteDataSource.updateTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<Todo> getTodoById(String todoId) async {
    final todoModel = await remoteDataSource.getTodoById(todoId);
    return todoModel.toEntity();
  }
}
