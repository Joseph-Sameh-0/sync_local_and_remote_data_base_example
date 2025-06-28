import 'package:isar/isar.dart';
import 'package:sync_local_and_remote_data_base_example/data/datasources/remote/dtos/todo_model.dart';
import '../../../../domain/entities/todo.dart';

part 'todo_entity.g.dart';

@collection
class TodoEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String title;
  late bool completed;
  late DateTime createdAt;

  TodoEntity({
    required this.id,
    required this.title,
    this.completed = false,
    required this.createdAt,
  });

  factory TodoEntity.fromDomain(Todo todo) {
    return TodoEntity(
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
      createdAt: todo.createdAt,
    );
  }

  Todo toDomain() {
    return Todo(
      id: id,
      title: title,
      completed: completed,
      createdAt: createdAt,
    );
  }

  factory TodoEntity.fromDto(TodoDto todoDto) {
    return TodoEntity(
      id: todoDto.id,
      title: todoDto.title,
      completed: todoDto.completed,
      createdAt: todoDto.createdAt,
    );
  }

  @override
  String toString() {
    return 'TodoEntity{id: $id, title: $title, completed: $completed, createdAt: $createdAt}';
  }
}
