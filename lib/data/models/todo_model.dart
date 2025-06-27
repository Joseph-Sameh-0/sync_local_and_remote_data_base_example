import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.completed,
    required super.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json, String id) {
    return TodoModel(
      id: id,
      title: json['title'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
      createdAt: todo.createdAt,
    );
  }

  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      completed: completed,
      createdAt: createdAt,
    );
  }

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, completed: $completed, createdAt: $createdAt)';
  }
}