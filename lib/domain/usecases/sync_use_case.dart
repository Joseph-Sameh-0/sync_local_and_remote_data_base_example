import '../repositories/todo_repository.dart';
import 'base_use_case.dart';

class SyncUseCase extends UseCase<void, NoParams> {
  final TodoRepository todoRepository;

  SyncUseCase({required this.todoRepository});

  @override
  Future<void> call(NoParams params) async {
    await todoRepository.syncTodos();
  }
}
