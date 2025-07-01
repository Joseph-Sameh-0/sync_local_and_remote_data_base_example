import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import '../../../core/services/network_info_service/network_info_service.dart';
import '../../../domain/Exception/exception_tree.dart';
import '../../../domain/entities/pos.dart';
import '../../../domain/repositories/pos/transaction_repository.dart';
import '../../datasources/local/pos/entities/operations/transaction_item_operation_entity.dart';
import '../../datasources/local/pos/entities/operations/transaction_operation_entity.dart';
import '../../datasources/local/pos/entities/transaction_entity.dart';
import '../../datasources/local/pos/entities/transaction_item_entity.dart';
import '../../datasources/local/pos/transaction_item_operation_data_source.dart';
import '../../datasources/local/pos/transaction_local_data_source.dart';
import '../../datasources/local/pos/transaction_operation_data_source.dart';
import '../../datasources/remote/pos/dtos/transaction_dto.dart';
import '../../datasources/remote/pos/dtos/transaction_item_dto.dart';
import '../../datasources/remote/pos/transaction_remote_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;
  final TransactionOperationDataSource transactionOperationDataSource;
  final TransactionItemOperationDataSource transactionItemOperationDataSource;
  final NetworkInfoService networkInfoService;
  StreamSubscription? _networkSub;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.transactionOperationDataSource,
    required this.transactionItemOperationDataSource,
    required this.networkInfoService,
  });

  @override
  Stream<List<Transaction>> getTransactions() {

    _networkSub ??= networkInfoService.onStatusChange.listen((isConnected) {
      if (isConnected) {
        remoteDataSource.getTransactions().listen((remoteTransactions) async {
          localDataSource.overrideTransactions(
            remoteTransactions
                .map((transaction) => TransactionEntity.fromDto(transaction))
                .toList(),
          );
        });
      }
    });



    // Always return local data stream for UI
    return localDataSource.getTransactions().map(
      (models) => models.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Transaction> getTransactionById(String transactionId) async {
    final transactionModel = await localDataSource.getTransactionById(
      transactionId,
    );
    if (transactionModel == null) {
      throw AppExceptions.domainException.transactionNotFoundException;
    }
    return transactionModel.toDomain();
  }

  @override
  Future<List<PendingUpdates>> getPendingTransactions() async {
    List<TransactionOperationEntity> transactionOperations =
    await transactionOperationDataSource.getAllOperations();

    List<TransactionItemOperationEntity> transactionItemOperations =
    await transactionItemOperationDataSource.getAllOperations();

    List<PendingUpdates> pendingTransactions = [];

    // Add Transaction-level operations
    for (var op in transactionOperations) {
      final changeData = <String, dynamic>{
        'type': 'transaction',
        'operation': op.operationType.name,
        // 'changed value': op.columnName,
        'value': op.value,
      };

      pendingTransactions.add(
        PendingUpdates(
          id: op.transactionId,
          action: op.operationType.name,
          changes: changeData,
          timestamp: op.timestamp,
        ),
      );
    }

    // Add TransactionItem-level operations
    for (var op in transactionItemOperations) {
      final changeData = <String, dynamic>{
        'type': 'transaction_item',
        'operation': op.operationType.name,
        // 'changed value': op.columnName,
        'value': op.value,
      };

      pendingTransactions.add(
        PendingUpdates(
          id: op.itemId, // or link to parent transactionId if available
          action: op.operationType.name,
          changes: changeData,
          timestamp: op.timestamp,
        ),
      );
    }

    // Sort by timestamp (most recent first)
    pendingTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return pendingTransactions;
  }

  @override
  Future<String> addTransaction(Transaction transaction) async {
    if (await networkInfoService.isConnected) {
      return await remoteDataSource.addTransaction(
        TransactionDto.fromDomain(transaction),
      );
    } else {
      transactionOperationDataSource.addTransaction(transaction);
      await localDataSource.addTransaction(
        TransactionEntity.fromDomain(transaction),
      );
      return transaction.id;
    }
  }

  @override
  Future<void> addTransactionItem({
    required TransactionItem transactionItem,
  }) async {
    if (await networkInfoService.isConnected) {
      await remoteDataSource.addTransactionItem(
        TransactionItemDto.fromDomain(transactionItem),
      );
    } else {
      transactionItemOperationDataSource.addItem(transactionItem);
      await localDataSource.addTransactionItem(
        TransactionItemEntity.fromDomain(transactionItem),
      );
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async{
    if (await networkInfoService.isConnected) {
      return remoteDataSource.deleteTransaction(transactionId);
    } else {
      transactionOperationDataSource.deleteTransaction(transactionId);
      return localDataSource.deleteTransaction(transactionId);
    }
  }

  @override
  Future<void> sync() async {

    // Step 1: Sync Transaction Operations
    List<TransactionOperationEntity> transactionOperations =
    await transactionOperationDataSource.getAllOperations();

    Map<String, String> transactionIdMap = {};

    for (var operation in transactionOperations) {

      try {
        switch (operation.operationType) {
          case TransactionOperationType.add:
            final transaction = Transaction.fromJson(
              jsonDecode(operation.value!),
            );
            String transactionId = await remoteDataSource.addTransaction(
              TransactionDto.fromDomain(transaction),
            );
            transactionIdMap[operation.transactionId] = transactionId;
            break;

          case TransactionOperationType.updateCreatedAt:
            final remoteTransaction = await remoteDataSource.getTransactionById(operation.transactionId);
            if (remoteTransaction == null) continue;

            if (remoteTransaction.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateTransaction(
                remoteTransaction.copyWith(createdAt: DateTime.parse(operation.value!)),
              );
            }
            break;

          case TransactionOperationType.updateTotal:
            final remoteTransaction = await remoteDataSource.getTransactionById(operation.transactionId);
            if (remoteTransaction == null) continue;

            final newTotal = double.tryParse(operation.value ?? '0.0') ?? 0.0;
            if (remoteTransaction.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateTransaction(
                remoteTransaction.copyWith(total: newTotal),
              );
            }
            break;

          case TransactionOperationType.delete:
            await remoteDataSource.deleteTransaction(operation.transactionId);
            break;
        }

        // If successful, remove the operation from local log
        await transactionOperationDataSource.deleteOperation(operation.id);

      } catch (e, s) {
        log("Sync failed for transaction operation ID: ${operation.id}, Error: $e");
        log(s.toString());
      }
    }

    // Step 2: Sync Transaction Item Operations
    List<TransactionItemOperationEntity> itemOperations =
    await transactionItemOperationDataSource.getAllOperations();

    for (var operation in itemOperations) {

      try {
        switch (operation.operationType) {
          case TransactionItemOperationType.add:
            final item = TransactionItem.fromJson(jsonDecode(operation.value!));
            await remoteDataSource.addTransactionItem(
              TransactionItemDto.fromDomain(item).copyWith(
                transactionId: transactionIdMap[item.transactionId] ?? item.transactionId,
              ),
            );
            break;

          case TransactionItemOperationType.updateQuantity:
            final remoteItem = await remoteDataSource.getTransactionItemById(operation.itemId);
            if (remoteItem == null) continue;

            final newQuantity = int.tryParse(operation.value ?? '0') ?? 0;
            if (remoteItem.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateTransactionItem(
                remoteItem.copyWith(quantity: newQuantity),
              );
            }
            break;

          case TransactionItemOperationType.updateSubtotal:
            final remoteItem = await remoteDataSource.getTransactionItemById(operation.itemId);
            if (remoteItem == null) continue;

            final newSubtotal = double.tryParse(operation.value ?? '0.0') ?? 0.0;
            if (remoteItem.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateTransactionItem(
                remoteItem.copyWith(subtotal: newSubtotal),
              );
            }
            break;

          case TransactionItemOperationType.remove:
            await remoteDataSource.deleteTransactionItem(operation.itemId);
            break;
        }

        // If successful, remove the operation from local log
        await transactionItemOperationDataSource.deleteOperation(operation.id);

      } catch (e, s) {
        log("Sync failed for transaction item operation ID: ${operation.id}, Error: $e");
        log(s.toString());
      }
    }

  }

  @override
  void dispose() {
    _networkSub?.cancel();
    _networkSub = null;
  }
}
