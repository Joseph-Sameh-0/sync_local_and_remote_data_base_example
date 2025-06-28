abstract class NetworkInfoDataSource {
  Future<bool> get isConnected;
  Stream<bool> get onStateChange;
}
