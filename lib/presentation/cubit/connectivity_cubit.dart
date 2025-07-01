import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/network_info_service/network_info_service.dart';
import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/sync_use_case.dart';
import 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final NetworkInfoService networkInfoService;
  final SyncUseCase syncUseCase;
  late final StreamSubscription _subscription;

  ConnectivityCubit({
    required this.networkInfoService,
    required this.syncUseCase,
  }) : super(ConnectivityInitial()) {
    ConnectivityLoading();
    _subscription = networkInfoService.onStatusChange.listen((
      isConnected,
    ) async {
      emit(isConnected ? ConnectivityConnected() : ConnectivityDisconnected());

      if (isConnected) {
        sync();
      }
    });
  }

  Future<void> sync() async {
    emit(ConnectivitySyncing());
    try {
      await syncUseCase(NoParams());
      emit(ConnectivityConnected());
    } catch (e) {
      emit(ConnectivitySyncError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
