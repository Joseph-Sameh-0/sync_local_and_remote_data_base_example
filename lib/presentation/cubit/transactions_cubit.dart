import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_local_and_remote_data_base_example/domain/entities/pos.dart';

import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/transactions_use_cases.dart';
import 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactionsUseCase getTransactionsUseCase;
  final GetPendingUpdatesUseCase getPendingTransactionsUseCase;

  StreamSubscription<List<Transaction>>? _transactionsSub;

  TransactionsCubit({
    required this.getTransactionsUseCase,
    required this.getPendingTransactionsUseCase,
  }) : super(TransactionsInitial());

  void loadTransactions() async {
    emit(TransactionsLoading());

    try {
      _transactionsSub?.cancel();
      _transactionsSub = getTransactionsUseCase(NoParams()).listen((transactions) async {
        final pendingTransactions = await getPendingTransactionsUseCase(
          NoParams(),
        );

        emit(
          TransactionsLoaded(
            transactions: transactions,
            pendingTransactions: pendingTransactions,
          ),
        );
      });
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _transactionsSub?.cancel();
    return super.close();
  }
}
