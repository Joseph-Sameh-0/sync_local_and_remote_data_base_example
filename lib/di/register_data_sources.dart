import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/datasources/abstract/operation_data_source.dart';
import '../data/datasources/abstract/todo_data_source.dart';
import '../data/datasources/local/entities/todo_entity.dart';
import '../data/datasources/local/operation_isar_data_source.dart';
import '../data/datasources/local/todo_local_data_source.dart';
import '../data/datasources/remote/dtos/todo_model.dart';
import '../data/datasources/remote/todo_remote_data_source.dart';
import 'injection_container.dart';

Future<void> registerDataSources() async {
  sl.registerLazySingleton<TodoDataSource<TodoDto>>(
    () => TodoFireStoreDataSource(firebaseService: sl()),
  );

  final appDir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([TodoEntitySchema], directory: appDir.path);

  sl.registerLazySingleton<Isar>(() => isar);

  sl.registerLazySingleton<TodoDataSource<TodoEntity>>(
    () => TodoIsarDataSource(db: sl()),
  );
  sl.registerLazySingleton<OperationDataSource>(
    () => OperationIsarDataSource(db: sl()),
  );
}
