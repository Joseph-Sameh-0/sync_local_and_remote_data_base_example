import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../abstract/network_info.dart';

class NetworkInfoRemoteDataSource implements NetworkInfoDataSource {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoRemoteDataSource({required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
