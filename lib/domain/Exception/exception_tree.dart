import 'domain_exceptions.dart';

class AppExceptions {
  const AppExceptions();

  static get dataExceptions => DataExceptions();

  static get domainException => DomainException();

  static get presentationExceptions => PresentationExceptions();
}

class DataExceptions {
  get updateProductEntityException => UpdateProductEntityException();

  get productEntityNotFoundException => ProductEntityNotFoundException();

  GetDataException getDataException(String path) => GetDataException(path);

  DocumentNotFoundException documentNotFoundException(String path) =>
      DocumentNotFoundException(path);

  get batchOperationException => BatchOperationException();

  FirebaseOperationException firebaseOperationException(
    String path,
    String? message,
  ) => FirebaseOperationException(path, message);

  UpdateDataException updateDataException(String path) =>
      UpdateDataException(path);

  StreamDataException streamDataException(String path) => StreamDataException(path);
}

class DomainException {
  get productNotFoundException => ProductNotFoundException();

  get productUpdateException => ProductNotUpdateException();

  get transactionNotFoundException => TransactionNotFoundException();

  get transactionNotUpdatedException => TransactionNotUpdatedException();

  get noInternetException => NoInternetException();
}

class PresentationExceptions {
  get invalidEmailOrPasswordException => InvalidEmailOrPasswordException();

  get addTransactionException => AddTransactionException();

  get loadTransactionsException => LoadTransactionsException();

  get toggleTransactionException => ToggleTransactionException();
}
