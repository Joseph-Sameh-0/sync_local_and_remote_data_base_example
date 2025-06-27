import 'package:equatable/equatable.dart';

import '../../domain/Exception/exceptions.dart';
import '../../domain/entities/todo.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  const TodoLoaded({required this.todos});

  @override
  List<Object> get props => [todos];
}

class TodoError extends TodoState {
  final MyException exception;

  const TodoError({required this.exception});

  @override
  List<Object> get props => [exception];
}
