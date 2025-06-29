abstract class NetworkInfoService {
  Future<bool> get isConnected;
  Stream<bool> get onStatusChange;
}