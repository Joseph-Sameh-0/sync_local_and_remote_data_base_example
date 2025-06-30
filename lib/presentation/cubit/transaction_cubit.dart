import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/Exception/exceptions.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/get_all_transactions_use_case.dart';
import '../../domain/usecases/watch_transactions.dart';
import '../../di/injection_container.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final WatchTransactionsUseCase watchTransactionsUseCase;
  final AddTransactionUseCase addTransactionUseCase;
  final GetAllTransactionsUseCase getAllTransactionsUseCase;
  StreamSubscription? _transactionsSubscription;

  TransactionCubit({
    required this.watchTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.getAllTransactionsUseCase,
  }) : super(TransactionInitial());

  void loadTransactions() {
    emit(TransactionLoading());
    _transactionsSubscription?.cancel();
    _transactionsSubscription = watchTransactionsUseCase(NoParams()).listen(
      (transactions) {
        emit(TransactionLoaded(transactions: transactions));
      },
      onError: (error) {
        emit(TransactionError(exception: LoadTransactionsException()));
      },
    );
  }

  Future<void> fetchAllTransactions() async {
    try {
      final transactions = await getAllTransactionsUseCase(NoParams());
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      log('Error fetching all transactions: $e');
      emit(TransactionError(exception: LoadTransactionsException()));
    }
  }

  Future<void> createTransaction(String title, int amount) async {
    try {
      final newTransaction = Transaction(
        id: const Uuid().v4(),
        title: title,
        amount: amount,
        createdAt: DateTime.now(),
        lastUpdate: DateTime.now(),
      );
      await addTransactionUseCase(newTransaction);
    } catch (e) {
      emit(TransactionError(exception: AddTransactionException()));
    }
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    sl<TransactionRepository>().dispose();
    return super.close();
  }
}
