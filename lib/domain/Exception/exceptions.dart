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

class AddTodoException extends MyException {
  AddTodoException() : super("Failed to add todo. Please try again.");
}

class LoadTodosException extends MyException {
  LoadTodosException() : super("Failed to load todos. Please try again.");
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

class ToggleTodoException extends MyException {
  ToggleTodoException() : super("Failed to toggle todo completion. Please try again.");
}