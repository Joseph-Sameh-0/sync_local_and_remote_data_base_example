
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/Exception/exceptions.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/get_all_todos_use_case.dart';
import '../../domain/usecases/toggle_complete_todo_use_case.dart';
import '../../domain/usecases/watch_todos.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final WatchTodosUseCase watchTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final ToggleCompleteTodoUseCase toggleCompleteTodoUseCase;
  final GetAllTodosUseCase getAllTodosUseCase;
  StreamSubscription? _todosSubscription;

  TodoCubit({
    required this.watchTodosUseCase,
    required this.addTodoUseCase,
    required this.toggleCompleteTodoUseCase,
    required this.getAllTodosUseCase,
  }) : super(TodoInitial());

  void loadTodos() {
    emit(TodoLoading());
    _todosSubscription?.cancel();
    _todosSubscription = watchTodosUseCase(NoParams()).listen((todos) {
      emit(TodoLoaded(todos: todos));
    }, onError: (error) {
      emit(TodoError(exception: LoadTodosException()));
    });
  }

  Future<void> fetchAllTodos() async {
    try {
      final todos = await getAllTodosUseCase(NoParams());
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      log('Error fetching all todos: $e');
      emit(TodoError(exception: LoadTodosException()));
    }
  }

  Future<void> createTodo(String title) async {
    try {
      final newTodo = Todo(
        id: const Uuid().v4(),
        title: title,
        completed: false,
        createdAt: DateTime.now(),
      );
      await addTodoUseCase(newTodo);
    } catch (e) {
      emit(TodoError(exception: AddTodoException()));
    }
  }

  Future<void> toggleTodoCompletion(String id, bool completed) async {
    try {
      await toggleCompleteTodoUseCase(id, completed);
    } catch (e) {
      emit(TodoError(exception: ToggleTodoException()));
    }
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}