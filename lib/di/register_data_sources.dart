import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/datasources/local/pos/entities/operations/product_operation_entity.dart';
import '../data/datasources/local/pos/entities/operations/transaction_item_operation_entity.dart';
import '../data/datasources/local/pos/entities/operations/transaction_operation_entity.dart';
import '../data/datasources/local/pos/product_local_data_source.dart';
import '../data/datasources/local/pos/product_operations_data_source.dart';
import '../data/datasources/remote/pos/product_remote_data_source.dart';

import '../data/datasources/local/pos/entities/product_entity.dart';
import '../data/datasources/local/pos/entities/transaction_entity.dart';
import '../data/datasources/local/pos/entities/transaction_item_entity.dart';
import '../data/datasources/local/pos/transaction_item_operation_data_source.dart';
import '../data/datasources/local/pos/transaction_local_data_source.dart';
import '../data/datasources/local/pos/transaction_operation_data_source.dart';
import '../data/datasources/remote/pos/transaction_remote_data_source.dart';
import 'injection_container.dart';

Future<void> registerDataSources() async {
  // sl.registerLazySingleton<TransactionRemoteDataSource>(
  //   () => TransactionFireStoreDataSource(firebaseService: sl()),
  // );

  // sl.registerLazySingleton<TransactionLocalDataSource>(
  //   () => TransactionIsarDataSource(db: sl()),
  // );
  // sl.registerLazySingleton<TransactionOperationDataSource>(
  //   () => TransactionOperationIsarDataSource(db: sl()),
  // );
  //

  final appDir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([
    // TransactionEntitySchema,
    // TransactionOperationEntitySchema,
    ProductEntitySchema,
    TransactionEntitySchema,
    TransactionItemEntitySchema,
    ProductOperationEntitySchema,
    TransactionItemOperationEntitySchema,
    TransactionOperationEntitySchema
  ], directory: appDir.path);

  sl.registerLazySingleton<Isar>(() => isar);

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductFireStoreDataSource(firebaseService: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductIsarDataSource(db: sl()),
  );

  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionFireStoreDataSource(firebaseService: sl()),
  );
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionIsarDataSource(db: sl()),
  );

  sl.registerLazySingleton<TransactionItemOperationDataSource>(
    () => TransactionItemOperationIsarDataSource(db: sl()),
  );
  sl.registerLazySingleton<TransactionOperationDataSource>(
    () => TransactionOperationIsarDataSource(db: sl()),
  );
  sl.registerLazySingleton<ProductOperationDataSource>(
    () => ProductOperationIsarDataSource(db: sl()),
  );

}
