import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/sync_use_case.dart';

class ConnectivityCubit extends Cubit<bool> {
  final InternetConnectionChecker internetConnectionChecker;
  final SyncUseCase syncUseCase;
  late final StreamSubscription _subscription;

  ConnectivityCubit({required this.internetConnectionChecker, required this.syncUseCase}) : super(true) {
    _subscription = internetConnectionChecker.onStatusChange.listen((status) async {
      final isConnected = status == InternetConnectionStatus.connected;
      emit(isConnected);

      if (isConnected) {
        await syncUseCase(NoParams());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
