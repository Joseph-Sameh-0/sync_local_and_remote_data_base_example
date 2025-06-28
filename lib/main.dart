import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart';
import 'presentation/cubit/connectivity_cubit.dart';
import 'presentation/cubit/todo_cubit.dart';
import 'presentation/features/todo/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(SyncApp());
}

class SyncApp extends StatelessWidget {
  const SyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Todo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => sl<ConnectivityCubit>(),
        child: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        return Column(
          children: [
            if (!isConnected)
              Container(
                width: double.infinity,
                color: Colors.red,
                padding: EdgeInsets.all(8),
                child: Text(
                  'No Internet Connection',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
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
