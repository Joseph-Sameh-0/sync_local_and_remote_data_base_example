import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/injection_container.dart';
import 'main_page.dart';
import 'presentation/cubit/connectivity_cubit.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Firebase Transaction',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => sl<ConnectivityCubit>(),
        child: Container(
          color: Colors.white,
            child: SafeArea(child: MainPage())),
      ),
    );
  }
}
