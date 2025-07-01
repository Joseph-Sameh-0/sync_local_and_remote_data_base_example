import 'dart:convert';

import 'package:isar/isar.dart';

import '../../../../domain/entities/pos.dart';
import 'entities/operations/product_operation_entity.dart';

abstract class ProductOperationDataSource {
  Future<void> addProduct(Product product);

  Future<void> updateProductName(String productId, String newName);

  Future<void> updateProductBarcode(String productId, String newBarcode);

  Future<void> updateProductPrice(String productId, double newPrice);

  Future<void> updateProductStock(String productId, int deltaStock);

  Future<void> deleteProduct(String productId);

  Future<void> deleteOperation(Id id);

  Future<List<ProductOperationEntity>> getAllOperations();
}

class ProductOperationIsarDataSource implements ProductOperationDataSource {
  final Isar db;

  ProductOperationIsarDataSource({required this.db});

  @override
  Future<void> addProduct(Product product) async {
    await db.writeTxn(() async {
      await db.productOperationEntitys.put(
        ProductOperationEntity(
          productId: product.productId,
          operationType: ProductOperationType.add,
          value: jsonEncode(product.toJson()),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateProductName(String productId, String newName) async {
    await db.writeTxn(() async {
      await db.productOperationEntitys.put(
        ProductOperationEntity(
          productId: productId,
          operationType: ProductOperationType.updateName,
          value: newName,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateProductBarcode(String productId, String newBarcode) async {
    await db.writeTxn(() async {
      await db.productOperationEntitys.put(
        ProductOperationEntity(
          productId: productId,
          operationType: ProductOperationType.updateBarcode,
          value: newBarcode,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateProductPrice(String productId, double newPrice) async {
    await db.writeTxn(() async {
      await db.productOperationEntitys.put(
        ProductOperationEntity(
          productId: productId,
          operationType: ProductOperationType.updatePrice,
          value: newPrice.toString(),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> updateProductStock(String productId, int deltaStock) async {
    await db.writeTxn(() async {
      await db.productOperationEntitys.put(
        ProductOperationEntity(
          productId: productId,
          operationType: ProductOperationType.updateStock,
          value: deltaStock.toString(),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await db.writeTxn(() async {
      await db.productOperationEntitys.put(
        ProductOperationEntity(
          productId: productId,
          operationType: ProductOperationType.delete,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Future<List<ProductOperationEntity>> getAllOperations() async {
    return await db.productOperationEntitys.where().findAll();
  }

  @override
  Future<void> deleteOperation(Id id) async {
    await db.writeTxn(() async {
      await db.productOperationEntitys.delete(id);
    });
  }
}