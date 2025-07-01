class BaseException implements Exception {
  final String message;

  BaseException(this.message);

  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is BaseException && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
