class MyException implements Exception {
  final String message;

  MyException(this.message);

  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MyException && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class NoInternetException extends MyException {
  NoInternetException()
    : super("No internet connection. Please check your network settings.");
}

class CollectionPathNotFoundException extends MyException {
  CollectionPathNotFoundException(String path)
    : super("Collection path $path not found.");
}

class DataFormatException extends MyException {
  DataFormatException(String path)
    : super('Data at $path is not in expected format');
}

class PermissionDeniedException extends MyException {
  PermissionDeniedException(String path)
    : super('Permission denied for path: $path');
}

class NetworkException extends MyException {
  NetworkException(String path) : super('Network error accessing path: $path');
}

class SetDataException extends MyException {
  SetDataException(String path) : super("Failed to set data at $path");
}

class GetDataException extends MyException {
  GetDataException(String path) : super("Failed to get data from $path");
}

class UpdateDataException extends MyException {
  UpdateDataException(String path) : super("Failed to Update data at $path");
}

class DeleteDataException extends MyException {
  DeleteDataException(String path) : super("Failed to delete data from $path");
}

class StreamDataException extends MyException {
  StreamDataException(String path) : super("Failed to Stream data from $path");
}

class FirebaseServiceException extends MyException {
  FirebaseServiceException(String path) : super('Firebase error at $path');
}

class InvalidEmailOrPasswordException extends MyException {
  InvalidEmailOrPasswordException()
    : super("Invalid email or password. Please try again.");
}

class AddTransactionException extends MyException {
  AddTransactionException() : super("Failed to add transaction. Please try again.");
}

class LoadTransactionsException extends MyException {
  LoadTransactionsException() : super("Failed to load transactions. Please try again.");
}

class DocumentNotFoundException extends MyException {
  DocumentNotFoundException(String path)
    : super("Document not found at $path");
}

class BatchOperationException extends MyException {
  BatchOperationException()
    : super("Batch operation failed");
}

class FirebaseOperationException extends MyException {
  FirebaseOperationException(String path, String? message)
    : super("Firebase operation failed at $path: $message");
}

class ToggleTransactionException extends MyException {
  ToggleTransactionException() : super("Failed to toggle transaction completion. Please try again.");
}

class TransactionNotFoundException extends MyException {
  TransactionNotFoundException() : super("Transaction not found.");
}

class TransactionDoesNotFoundException extends MyException {
  TransactionDoesNotFoundException() : super("Transaction does not exist");
}

class TransactionNotUpdatedException extends MyException {
  TransactionNotUpdatedException() : super("Failed to update transaction. Please try again.");
}