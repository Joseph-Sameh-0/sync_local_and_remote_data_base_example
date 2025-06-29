import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_info_service.dart';

class NetworkInfoServiceConnectionChecker implements NetworkInfoService {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoServiceConnectionChecker({required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Stream<bool> get onStatusChange => connectionChecker.onStatusChange.map(
    (status) => status == InternetConnectionStatus.connected,
  );
}
