import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/pos.dart';
import '../../cubit/transactions_cubit.dart';
import '../../cubit/transactions_state.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (state is TransactionsInitial || state is TransactionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<TransactionsCubit>().loadTransactions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is TransactionsLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return _buildMobileLayout(context, state);
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildAllTransactionsList(state.transactions),
                      ),
                      Expanded(
                        child: _buildPendingTransactionsList(
                          state.pendingTransactions,
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, TransactionsLoaded state) {
    return Column(
      children: [
        Expanded(child: _buildAllTransactionsList(state.transactions)),
        SizedBox(
          height: 250,
          child: _buildPendingTransactionsList(state.pendingTransactions),
        ),
      ],
    );
  }

  Widget _buildAllTransactionsList(List<Transaction> transactions) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Transactions (${transactions.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (transactions.isEmpty)
              const Center(child: Text('No transactions found.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return ListTile(
                      title: Text(transaction.createdAt.toIso8601String()),
                      subtitle: Text(
                        '\$${transaction.total.toStringAsFixed(2)}',
                      ),
                      trailing: Text('${transaction.items.length} items'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTransactionsList(List pendingTransactions) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Transactions (${pendingTransactions.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (pendingTransactions.isEmpty)
              const Center(child: Text('No pending transactions.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: pendingTransactions.length,
                  itemBuilder: (context, index) {
                    final PendingTransaction item = pendingTransactions[index];
                    return ListTile(
                      title: Text('Action: ${item.action}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Changes: ${item.changes}'),
                          Text('Timestamp: ${item.timestamp}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
