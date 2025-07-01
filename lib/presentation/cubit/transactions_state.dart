
import 'package:equatable/equatable.dart';

import '../../domain/entities/pos.dart';

abstract class TransactionsState extends Equatable{
  const TransactionsState();
  @override
  List<Object?> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<Transaction> transactions;
  final List pendingTransactions;

  const TransactionsLoaded({required this.transactions, required this.pendingTransactions});

  @override
  List<Object?> get props => [transactions, pendingTransactions];
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError(this.message);

  @override
  List<Object?> get props => [message];
}