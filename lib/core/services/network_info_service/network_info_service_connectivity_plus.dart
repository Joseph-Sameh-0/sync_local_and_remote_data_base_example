import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info_service.dart';

class NetworkInfoServiceConnectivityPlus implements NetworkInfoService {
  final Connectivity connectivity;

  NetworkInfoServiceConnectivityPlus({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !(result.contains(ConnectivityResult.none));
  }

  @override
  Stream<bool> get onStatusChange => connectivity.onConnectivityChanged.map(
    (result) => !(result.contains(ConnectivityResult.none)),
  );
}
