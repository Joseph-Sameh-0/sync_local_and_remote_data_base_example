import 'dart:async';

import 'package:sync_local_and_remote_data_base_example/data/datasources/local/entities/todo_entity.dart';

import '../../domain/Exception/exceptions.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/abstract/network_info.dart';
import '../datasources/abstract/todo_data_source.dart';
import '../datasources/remote/dtos/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource<TodoDto> remoteDataSource;
  final TodoDataSource<TodoEntity> localDataSource;
  final NetworkInfoDataSource networkInfoDataSource;
  StreamSubscription? _networkSub;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfoDataSource,
  });

  @override
  Stream<List<Todo>> watchTodos() {
    _networkSub ??= networkInfoDataSource.onStateChange.listen((isConnected) {
      if (isConnected) {
        remoteDataSource.watchTodos().listen((remoteTodos) async {
          localDataSource.overrideTodos(
            remoteTodos.map((todo) => TodoEntity.fromDto(todo)).toList(),
          );
        });
      }
    });

    // Always return local data stream for UI
    return localDataSource.watchTodos().map(
          (models) => models.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    if (await networkInfoDataSource.isConnected) {
      final remoteTodos = await remoteDataSource.getAllTodos();
      await localDataSource.overrideTodos(
        remoteTodos.map((todo) => TodoEntity.fromDto(todo)).toList(),
      );
    }
    final todoEntities = await localDataSource.getAllTodos();
    return todoEntities.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    if (await networkInfoDataSource.isConnected) {
      await remoteDataSource.addTodo(TodoDto.fromDomain(todo));
    } else {
      await localDataSource.addTodo(TodoEntity.fromDomain(todo));
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (await networkInfoDataSource.isConnected) {
      return remoteDataSource.deleteTodo(id);
    } else {
      return localDataSource.deleteTodo(id);
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      if (await networkInfoDataSource.isConnected) {
        return remoteDataSource.updateTodo(TodoDto.fromDomain(todo));
      } else {
        return localDataSource.updateTodo(TodoEntity.fromDomain(todo));
      }
    } catch (e) {
      throw TodoNotUpdatedException();
    }
  }

  @override
  Future<Todo> getTodoById(String todoId) async {
    final todoModel = await localDataSource.getTodoById(todoId);
    if (todoModel == null) {
      throw ToDoNotFoundException();
    }
    return todoModel.toDomain();
  }

  @override
  void dispose() {
    _networkSub?.cancel();
  }

  @override
  Future<void> syncTodos() {
    // // TODO: implement syncTodos
    print("object");
    return Future.value();
  }
}
