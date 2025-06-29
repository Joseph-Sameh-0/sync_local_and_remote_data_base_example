import 'dart:async';

import '../../domain/Exception/exceptions.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../core/services/network_info_service/network_info_service.dart';
import '../datasources/abstract/operation_data_source.dart';
import '../datasources/abstract/todo_data_source.dart';
import '../datasources/local/entities/todo_entity.dart';
import '../datasources/remote/dtos/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource<TodoDto> remoteDataSource;
  final TodoDataSource<TodoEntity> localDataSource;
  final NetworkInfoService networkInfoService;
  final OperationDataSource operationDataSource;
  StreamSubscription? _networkSub;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfoService,
    required this.operationDataSource,
  });

  @override
  Stream<List<Todo>> watchTodos() {
    _networkSub ??= networkInfoService.onStatusChange.listen((isConnected) {
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
    if (await networkInfoService.isConnected) {
      final remoteTodos = await remoteDataSource.getAllTodos();
      await localDataSource.overrideTodos(
        remoteTodos.map((todo) => TodoEntity.fromDto(todo)).toList(),
      );
    }
    final todoEntities = await localDataSource.getAllTodos();
    return todoEntities.map((model) => model.toDomain()).toList();
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
  Future<void> addTodo(Todo todo) async {
    if (await networkInfoService.isConnected) {
      await remoteDataSource.addTodo(TodoDto.fromDomain(todo));
    } else {
      // TODO save changes to
      await localDataSource.addTodo(TodoEntity.fromDomain(todo));
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (await networkInfoService.isConnected) {
      return remoteDataSource.deleteTodo(id);
    } else {
      return localDataSource.deleteTodo(id);
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      if (await networkInfoService.isConnected) {
        return remoteDataSource.updateTodo(TodoDto.fromDomain(todo));
      } else {
        return localDataSource.updateTodo(TodoEntity.fromDomain(todo));
      }
    } catch (e) {
      throw TodoNotUpdatedException();
    }
  }


  @override
  Future<void> syncTodos() {
    // // TODO: implement syncTodos
    print("object");
    return Future.value();
  }

  @override
  void dispose() {
    _networkSub?.cancel();
  }

}
