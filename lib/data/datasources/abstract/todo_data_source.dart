abstract class TodoDataSource<T> {
  Stream<List<T>> watchTodos();

  Future<void> addTodo(T todo);

  Future<void> updateTodo(T todo);

  Future<void> deleteTodo(String id);

  Future<T?> getTodoById(String todoId);

  Future<List<T>> getAllTodos();

  Future<void> batchUpdateTodos(List<T> todos);

  Future<void> overrideTodos(List<T> todos);
}
