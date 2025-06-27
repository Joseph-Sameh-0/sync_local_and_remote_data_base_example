import '../../models/todo_model.dart';
import '../abstract/firebase_service.dart';
import '../abstract/todo_data_source.dart';
import '../utils/write_operation.dart';

class TodoFireStoreDataSource implements TodoDataSource {
  final FirebaseService firebaseService;
  final String todosPath = 'todos';

  TodoFireStoreDataSource({required this.firebaseService});

  @override
  Stream<List<TodoModel>> watchTodos() {
    return firebaseService.streamCollection<TodoModel>(
      path: todosPath,
      fromJson: TodoModel.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await firebaseService.addToCollection(path: todosPath, data: todo.toJson());
  }

  @override
  Future<void> deleteTodo(String id) async {
    await firebaseService.deleteDoc(path: '$todosPath/$id');
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await firebaseService.updateDoc(
      path: '$todosPath/${todo.id}',
      data: todo.toJson(),
    );
  }

  @override
  Future<TodoModel> getTodoById(String todoId) async {
    return await firebaseService.getDoc<TodoModel>(
      path: '$todosPath/$todoId',
      fromJson: TodoModel.fromJson,
    );
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    return await firebaseService.getCollection<TodoModel>(
      path: todosPath,
      fromJson: TodoModel.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<void> batchUpdateTodos(List<TodoModel> todos) async {
    final operations = todos
        .map(
          (todo) =>
              WriteOperation.update('$todosPath/${todo.id}', todo.toJson()),
        )
        .toList();

    await firebaseService.batchWrite(operations);
  }
}
