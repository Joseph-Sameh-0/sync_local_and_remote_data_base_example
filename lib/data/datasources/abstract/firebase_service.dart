// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/write_operation.dart';

abstract class FirebaseService {
  Future<T?> getDoc<T>({
    required String path,
    required T Function(Map<String, dynamic> json, String id) fromJson,
  });

  Future<void> updateDoc({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<void> deleteDoc({required String path});

  Future<void> batchWrite(List<WriteOperation> operations);

  Stream<T?> streamDoc<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
  });

  Future<String> addToCollection({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> json, String id) fromJson,
    Query Function(Query query)? queryBuilder,
    int? limit,
  });

  Stream<List<T>> streamCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> json, String id) fromJson,
    Query Function(Query query)? queryBuilder,
    int? limit,
  });
}
