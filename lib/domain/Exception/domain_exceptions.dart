

import 'base_exceptions.dart';

class NoInternetException extends BaseException {
  NoInternetException()
      : super("No internet connection. Please check your network settings.");
}

class CollectionPathNotFoundException extends BaseException {
  CollectionPathNotFoundException(String path)
      : super("Collection path $path not found.");
}

class DataFormatException extends BaseException {
  DataFormatException(String path)
      : super('Data at $path is not in expected format');
}

class PermissionDeniedException extends BaseException {
  PermissionDeniedException(String path)
      : super('Permission denied for path: $path');
}

class NetworkException extends BaseException {
  NetworkException(String path) : super('Network error accessing path: $path');
}

class SetDataException extends BaseException {
  SetDataException(String path) : super("Failed to set data at $path");
}

class GetDataException extends BaseException {
  GetDataException(String path) : super("Failed to get data from $path");
}

class UpdateDataException extends BaseException {
  UpdateDataException(String path) : super("Failed to Update data at $path");
}

class DeleteDataException extends BaseException {
  DeleteDataException(String path) : super("Failed to delete data from $path");
}

class StreamDataException extends BaseException {
  StreamDataException(String path) : super("Failed to Stream data from $path");
}

class FirebaseServiceException extends BaseException {
  FirebaseServiceException(String path) : super('Firebase error at $path');
}

class InvalidEmailOrPasswordException extends BaseException {
  InvalidEmailOrPasswordException()
      : super("Invalid email or password. Please try again.");
}

class AddTransactionException extends BaseException {
  AddTransactionException()
      : super("Failed to add transaction. Please try again.");
}

class LoadTransactionsException extends BaseException {
  LoadTransactionsException()
      : super("Failed to load transactions. Please try again.");
}

class DocumentNotFoundException extends BaseException {
  DocumentNotFoundException(String path) : super("Document not found at $path");
}

class BatchOperationException extends BaseException {
  BatchOperationException() : super("Batch operation failed");
}

class FirebaseOperationException extends BaseException {
  FirebaseOperationException(String path, String? message)
      : super("Firebase operation failed at $path: $message");
}

class ToggleTransactionException extends BaseException {
  ToggleTransactionException()
      : super("Failed to toggle transaction completion. Please try again.");
}

class TransactionNotFoundException extends BaseException {
  TransactionNotFoundException() : super("Transaction not found.");
}

class TransactionNotUpdatedException extends BaseException {
  TransactionNotUpdatedException()
      : super("Failed to update transaction. Please try again.");
}

class ProductNotFoundException extends BaseException {
  ProductNotFoundException() : super("Product not found.");
}

class ProductNotUpdateException extends BaseException {
  ProductNotUpdateException()
      : super("Failed to update product. Please try again.");
}

class UpdateProductEntityException extends BaseException {
  UpdateProductEntityException()
      : super("Failed to update product entity.");
}

class ProductEntityNotFoundException extends BaseException {
  ProductEntityNotFoundException()
      : super("Product entity not found in local database.");
}