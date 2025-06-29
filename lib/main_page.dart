import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart';
import 'presentation/cubit/connectivity_cubit.dart';
import 'presentation/cubit/connectivity_state.dart';
import 'presentation/cubit/todo_cubit.dart';
import 'presentation/features/todo/todo_page.dart';

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
              style: TextStyle(color: Colors.white),
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
              style: TextStyle(color: Colors.white),
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
              child: BlocProvider(
                create: (_) => sl<TodoCubit>()..loadTodos(),
                child: TodoPage(),
              ),
            ),
          ],
        );
      },
    );
  }
}
