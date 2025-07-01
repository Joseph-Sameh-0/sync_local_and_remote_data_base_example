abstract class ConnectivityState{}
class ConnectivityInitial extends ConnectivityState {}
class ConnectivityLoading extends ConnectivityState {}
class ConnectivityConnected extends ConnectivityState {}
class ConnectivityDisconnected extends ConnectivityState {}
class ConnectivitySyncing extends ConnectivityState {}
class ConnectivitySyncError extends ConnectivityState {
  final String message;

  ConnectivitySyncError(this.message);

  @override
  String toString() => message;
}