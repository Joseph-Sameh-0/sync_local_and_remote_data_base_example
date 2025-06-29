import '../../../../domain/entities/todo.dart';

class TodoDto {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  TodoDto({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  factory TodoDto.fromJson(Map<String, dynamic> json, String id) {
    return TodoDto(
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

  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
      createdAt: todo.createdAt,
    );
  }

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, completed: $completed, createdAt: $createdAt)';
  }
}
