import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/datasources/utils/write_operation.dart';
import '../../../domain/Exception/exception_tree.dart';
import 'firebase_service.dart';

class FirebaseServiceImpl implements FirebaseService {
  final FirebaseFirestore firestore;

  FirebaseServiceImpl({required this.firestore});

  @override
  Future<T?> getDoc<T>({
    required String path,
    required T Function(Map<String, dynamic> json, String id) fromJson,
  }) async {
    try {
      final snapshot = await firestore.doc(path).get();
      if (!snapshot.exists) {
        throw AppExceptions.dataExceptions.documentNotFoundException(path);
      }
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      return fromJson(data, snapshot.id);
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e, path);
    } catch (e) {
      throw AppExceptions.dataExceptions.getDataException(path);
    }
  }

  @override
  Future<void> updateDoc({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      await firestore.doc(path).update(data);
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e, path);
    } catch (e) {
      throw AppExceptions.dataExceptions.updateDataException(path);
    }
  }

  @override
  Future<void> deleteDoc({required String path}) async {
    try {
      await firestore.doc(path).delete();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e, path);
    } catch (e) {
      throw AppExceptions.dataExceptions.deleteDataException(path);
    }
  }

  @override
  Future<void> batchWrite(List<WriteOperation> operations) async {
    try {
      final batch = firestore.batch();
      for (final op in operations) {
        switch (op.type) {
          case WriteOperationType.set:
            final docRef = firestore.doc(op.path);
            batch.set(docRef, op.data!, SetOptions(merge: op.merge));
            break;
          case WriteOperationType.update:
            batch.update(firestore.doc(op.path), op.data!);
            break;
          case WriteOperationType.delete:
            batch.delete(firestore.doc(op.path));
            break;
        }
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e, 'batch_write');
    } catch (e) {
      throw AppExceptions.dataExceptions.batchOperationException;
    }
  }

  @override
  Stream<T?> streamDoc<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    return firestore
        .doc(path)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) {
            throw AppExceptions.dataExceptions.documentNotFoundException(path);
          }
          final data = snapshot.data();
          if (data == null) {
            return null;
          }
          return fromJson(data);
        })
        .handleError((error) {
          if (error is FirebaseException) {
            throw _handleFirebaseException(error, path);
          }
          throw AppExceptions.dataExceptions.streamDataException(path);
        });
  }

  @override
  Future<String> addToCollection({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await firestore.collection(path).add(data);
      return docRef.id;
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e, path);
    } catch (e) {
      throw AppExceptions.dataExceptions.setDataException(path);
    }
  }

  @override
  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> json, String id) fromJson,
    Query Function(Query query)? queryBuilder,
    int? limit,
  }) async {
    try {
      Query query = firestore.collection(path);
      if (queryBuilder != null) query = queryBuilder(query);
      if (limit != null) query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e, path);
    } catch (e) {
      throw AppExceptions.dataExceptions.getDataException(path);
    }
  }

  @override
  Stream<List<T>> streamCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> json, String id) fromJson,
    Query Function(Query query)? queryBuilder,
    int? limit,
  }) {
    Query query = firestore.collection(path);
    if (queryBuilder != null) query = queryBuilder(query);
    if (limit != null) query = query.limit(limit);

    return query
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => fromJson(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
        })
        .handleError((error) {
          if (error is FirebaseException) {
            throw _handleFirebaseException(error, path);
          }
          throw AppExceptions.dataExceptions.streamDataException(path);
        });
  }

  Exception _handleFirebaseException(FirebaseException e, String path) {
    switch (e.code) {
      case 'permission-denied':
        return AppExceptions.dataExceptions.permissionDeniedException(path);
      case 'not-found':
        return AppExceptions.dataExceptions.documentNotFoundException(path);
      case 'unavailable':
        return AppExceptions.dataExceptions.networkException(path);
      default:
        return AppExceptions.dataExceptions.firebaseOperationException(
          path,
          e.message,
        );
    }
  }
}
