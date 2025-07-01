import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/injection_container.dart';
import 'presentation/cubit/connectivity_cubit.dart';
import 'presentation/cubit/connectivity_state.dart';
import 'presentation/cubit/pos_cubit.dart';
import 'presentation/cubit/transactions_cubit.dart';
import 'presentation/features/pos/pos_page.dart';
import 'presentation/features/pos/transactions_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        Widget? widget;
        if (state is ConnectivityInitial || state is ConnectivityLoading) {
          widget = const LinearProgressIndicator();
        } else if (state is ConnectivitySyncing) {
          widget = Container(
            width: double.infinity,
            color: Colors.green,
            padding: EdgeInsets.all(8),
            child: Text(
              'Syncing...',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        } else if (state is ConnectivityDisconnected) {
          widget = Container(
            width: double.infinity,
            color: Colors.red,
            padding: EdgeInsets.all(8),
            child: Text(
              'No Internet Connection',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        } else if (state is ConnectivityConnected) {
          widget = const SizedBox.shrink();
        }
        return Column(
          children: [
            ?widget,
            Expanded(
              child: Navigator(
                onGenerateRoute: (settings) {
                  if (settings.name == '/') {
                    return MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<POSCubit>()..loadProducts(),
                        child: POSPage(),
                      ),
                    );
                  }
                  if (settings.name == '/transactions') {
                    return MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            sl<TransactionsCubit>()..loadTransactions(),
                        child: TransactionsPage(),
                      ),
                    );
                  }
                  return MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => sl<POSCubit>()..loadProducts(),
                      child: POSPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
