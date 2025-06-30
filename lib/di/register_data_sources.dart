import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sync_local_and_remote_data_base_example/data/datasources/local/entities/transaction_operation_entity.dart';

import '../data/datasources/local/entities/transaction_entity.dart';
import '../data/datasources/local/operation_isar_data_source.dart';
import '../data/datasources/local/transaction_local_data_source.dart';
import '../data/datasources/remote/transaction_remote_data_source.dart';
import 'injection_container.dart';

Future<void> registerDataSources() async {
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionFireStoreDataSource(firebaseService: sl()),
  );

  final appDir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([
    TransactionEntitySchema,
    TransactionOperationEntitySchema,
  ], directory: appDir.path);

  sl.registerLazySingleton<Isar>(() => isar);

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionIsarDataSource(db: sl()),
  );
  sl.registerLazySingleton<TransactionOperationDataSource>(
    () => TransactionOperationIsarDataSource(db: sl()),
  );
}
