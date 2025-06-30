import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:sync_local_and_remote_data_base_example/data/datasources/local/entities/transaction_operation_entity.dart';
import 'package:sync_local_and_remote_data_base_example/data/datasources/remote/transaction_remote_data_source.dart';

import '../../core/services/network_info_service/network_info_service.dart';
import '../../domain/Exception/exceptions.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/entities/transaction_entity.dart';
import '../datasources/local/operation_isar_data_source.dart';
import '../datasources/local/transaction_local_data_source.dart';
import '../datasources/remote/dtos/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;
  final NetworkInfoService networkInfoService;
  final TransactionOperationDataSource operationDataSource;
  StreamSubscription? _networkSub;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfoService,
    required this.operationDataSource,
  });

  @override
  Stream<List<Transaction>> watchTransactions() {
    _networkSub ??= networkInfoService.onStatusChange.listen((isConnected) {
      if (isConnected) {
        remoteDataSource.watchTransactions().listen((remoteTransactions) async {
          localDataSource.overrideTransactions(
            remoteTransactions
                .map((transaction) => TransactionEntity.fromDto(transaction))
                .toList(),
          );
        });
      }
    });

    // Always return local data stream for UI
    return localDataSource.watchTransactions().map(
      (models) => models.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    if (await networkInfoService.isConnected) {
      final remoteTransactions = await remoteDataSource.getAllTransactions();
      await localDataSource.overrideTransactions(
        remoteTransactions
            .map((transaction) => TransactionEntity.fromDto(transaction))
            .toList(),
      );
    }
    final transactionEntities = await localDataSource.getAllTransactions();
    return transactionEntities.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Transaction> getTransactionById(String transactionId) async {
    final transactionModel = await localDataSource.getTransactionById(
      transactionId,
    );
    if (transactionModel == null) {
      throw TransactionNotFoundException();
    }
    return transactionModel.toDomain();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    if (await networkInfoService.isConnected) {
      await remoteDataSource.addTransaction(
        TransactionDto.fromDomain(transaction),
      );
    } else {
      operationDataSource.addTransaction(transaction);
      await localDataSource.addTransaction(
        TransactionEntity.fromDomain(transaction),
      );
    }
  }

  @override
  Future<void> updateTransactionTitle(
    Transaction updatedTransaction,
    String newTitle,
  ) async {
    try {
      if (await networkInfoService.isConnected) {
        return remoteDataSource.updateTransaction(
          TransactionDto.fromDomain(updatedTransaction),
        );
      } else {
        operationDataSource.updateTransactionTitle(
          updatedTransaction.id,
          newTitle,
        );

        return localDataSource.updateTransaction(
          TransactionEntity.fromDomain(updatedTransaction),
        );
      }
    } catch (e) {
      throw TransactionNotUpdatedException();
    }
  }

  @override
  Future<void> updateTransactionAmount(
    Transaction updatedTransaction,
    int deltaAmount,
  ) async {
    try {
      if (await networkInfoService.isConnected) {
        return remoteDataSource.updateTransaction(
          TransactionDto.fromDomain(updatedTransaction),
        );
      } else {
        operationDataSource.updateTransactionAmount(
          updatedTransaction.id,
          deltaAmount,
        );
        return localDataSource.updateTransaction(
          TransactionEntity.fromDomain(updatedTransaction),
        );
      }
    } catch (e) {
      throw TransactionNotUpdatedException();
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    if (await networkInfoService.isConnected) {
      return remoteDataSource.deleteTransaction(id);
    } else {
      operationDataSource.deleteTransaction(id);
      return localDataSource.deleteTransaction(id);
    }
  }

  @override
  Future<void> syncTransactions() async {
    List<TransactionOperationEntity> transactionOperations =
        await operationDataSource.getAllOperations();
    int attempt = 3;
    for (var operation in transactionOperations) {
      if(attempt == 0) return;
      try {
        switch (operation.operationType) {
          case TransactionOperationType.add:
            final transaction = Transaction.fromJson(
              jsonDecode(operation.entity!),
            );
            await remoteDataSource.addTransaction(
              TransactionDto.fromDomain(transaction),
            );
            break;
          case TransactionOperationType.updateTitle:
            final transaction = await remoteDataSource.getTransactionById(
              operation.itemId,
            );
            if (transaction == null) {
              await operationDataSource.deleteOperation(operation.id);
              continue;
            }
            if(transaction.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateTransaction(
                transaction.copyWith(title: operation.value),
              );
            }
            break;
          case TransactionOperationType.updateAmount:
            final transaction = await remoteDataSource.getTransactionById(
              operation.itemId,
            );
            if (transaction == null) {
              await operationDataSource.deleteOperation(operation.id);
              continue;
            }
            int newAmount = transaction.amount + (operation.value as int);
            await remoteDataSource.updateTransaction(
              transaction.copyWith(amount: newAmount),
            );
            break;
          case TransactionOperationType.delete:
            await remoteDataSource.deleteTransaction(operation.itemId);
            break;
        }
        await operationDataSource.deleteOperation(operation.id);
      } catch (e) {
        log(e.toString());
        attempt--;
        continue;
      }
    }
    return Future.value();
  }

  @override
  void dispose() {
    _networkSub?.cancel();
  }
}
