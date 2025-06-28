import 'package:isar/isar.dart';
import 'package:sync_local_and_remote_data_base_example/data/datasources/local/entities/todo_entity.dart';

import '../../../domain/Exception/exceptions.dart';
import '../abstract/todo_data_source.dart';

class TodoIsarDataSource implements TodoDataSource<TodoEntity> {
  final Isar db;

  TodoIsarDataSource({required this.db});

  @override
  Stream<List<TodoEntity>> watchTodos() async* {
    yield* db.todoEntitys.where().watch(fireImmediately: true);
  }

  @override
  Future<void> addTodo(TodoEntity todo) async {
    await db.writeTxn(() async {
      await db.todoEntitys.put(todo);
    });
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    final existingTodo = await db.todoEntitys
        .where()
        .idEqualTo(todo.id)
        .findFirst();
    if (existingTodo != null) {
      try {
        await db.writeTxn(() async {
          await db.todoEntitys.put(todo..isarId = existingTodo.isarId);
        });
      } catch (e) {
        throw TodoNotUpdatedException();
      }
    } else {
      throw TodoDoesNotFoundException();
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todo = await db.todoEntitys.where().idEqualTo(id).findFirst();
    if (todo != null) {
      await db.writeTxn(() async {
        await db.todoEntitys.delete(todo.isarId);
      });
    }
  }

  @override
  Future<void> batchUpdateTodos(List<TodoEntity> todos) async {
    final ids = todos.map((e) => e.id).toList();
    final existing = await db.todoEntitys
        .where()
        .anyOf(ids, (q, id) => q.idEqualTo(id))
        .findAll();

    final todosWithIsarId = todos.map((todo) {
      final match = existing.firstWhere(
        (e) => e.id == todo.id,
        orElse: () => todo,
      );
      return todo..isarId = match.isarId;
    }).toList();

    await db.writeTxn(() async {
      await db.todoEntitys.putAll(todosWithIsarId);
    });
  }

  @override
  Future<List<TodoEntity>> getAllTodos() {
    return db.todoEntitys.where().findAll();
  }

  @override
  Future<TodoEntity?> getTodoById(String todoId) async {
    return db.todoEntitys.where().idEqualTo(todoId).findFirst();
  }

  @override
  Future<void> overrideTodos(List<TodoEntity> todos) async {
    await db.writeTxn(() async {
      await db.todoEntitys.clear();
      await db.todoEntitys.putAll(todos);
    });
  }
}
