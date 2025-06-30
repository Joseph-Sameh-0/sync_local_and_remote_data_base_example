import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/transaction_cubit.dart';
import '../../cubit/transaction_state.dart';

class TransactionPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Transaction title',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<TransactionCubit>().createTransaction(
                        _controller.text,
                        0
                      );
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionError) {
                  return Center(
                    child: Column(
                      children: [
                        Text(state.exception.toString()),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TransactionCubit>().loadTransactions();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is TransactionLoaded) {
                  return ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = state.transactions[index];
                      return ListTile(
                        title: Text(transaction.title),
                      );
                    },
                  );
                }
                return const Center(child: Text('No transactions yet'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
