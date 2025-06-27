class Todo {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}