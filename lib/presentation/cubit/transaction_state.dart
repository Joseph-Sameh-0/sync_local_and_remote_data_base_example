import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;

  const TransactionLoaded({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionError extends TransactionState {
  final Exception exception;

  const TransactionError({required this.exception});

  @override
  List<Object> get props => [exception];
}
