import 'package:flutter_bloc/flutter_bloc.dart';

import 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit() : super(TransactionsInitial());

  void loadTransactions() {
    // Logic to load transactions
  }
}
