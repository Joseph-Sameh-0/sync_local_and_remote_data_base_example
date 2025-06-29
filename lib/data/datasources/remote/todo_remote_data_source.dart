import '../../datasources/remote/dtos/todo_model.dart';
import '../../../core/services/firebase_service/firebase_service.dart';
import '../abstract/todo_data_source.dart';
import '../utils/write_operation.dart';

class TodoFireStoreDataSource implements TodoDataSource<TodoDto> {
  final FirebaseService firebaseService;
  final String todosPath = 'todos';

  TodoFireStoreDataSource({required this.firebaseService});

  @override
  Stream<List<TodoDto>> watchTodos() {
    return firebaseService.streamCollection<TodoDto>(
      path: todosPath,
      fromJson: TodoDto.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<void> addTodo(TodoDto todo) async {
    await firebaseService.addToCollection(path: todosPath, data: todo.toJson());
  }

  @override
  Future<void> deleteTodo(String id) async {
    await firebaseService.deleteDoc(path: '$todosPath/$id');
  }

  @override
  Future<void> updateTodo(TodoDto todo) async {
    await firebaseService.updateDoc(
      path: '$todosPath/${todo.id}',
      data: todo.toJson(),
    );
  }

  @override
  Future<TodoDto?> getTodoById(String todoId) async {
    return await firebaseService.getDoc<TodoDto>(
      path: '$todosPath/$todoId',
      fromJson: TodoDto.fromJson,
    );
  }

  @override
  Future<List<TodoDto>> getAllTodos() async {
    return await firebaseService.getCollection<TodoDto>(
      path: todosPath,
      fromJson: TodoDto.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<void> batchUpdateTodos(List<TodoDto> todos) async {
    final operations = todos
        .map(
          (todo) =>
              WriteOperation.update('$todosPath/${todo.id}', todo.toJson()),
        )
        .toList();

    await firebaseService.batchWrite(operations);
  }

  @override
  Future<void> overrideTodos(List<TodoDto> todos) async {
    final operations = todos
        .map(
          (todo) => WriteOperation.set(
            '$todosPath/${todo.id}',
            todo.toJson(),
            merge: true,
          ),
        )
        .toList();

    await firebaseService.batchWrite(operations);
    //not tested
  }
}
