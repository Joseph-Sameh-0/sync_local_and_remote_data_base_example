import 'package:isar/isar.dart';

import '../../../../domain/Exception/exception_tree.dart';
import 'entities/product_entity.dart';

abstract class ProductLocalDataSource {
  Stream<List<ProductEntity>> getProducts();

  Future<ProductEntity?> getProductById(String productId);

  Future<void> addProduct(ProductEntity product);

  Future<void> updateProduct(ProductEntity product);

  Future<void> deleteProduct(String productId);

  Future<void> overrideProducts(List<ProductEntity> products);
}

class ProductIsarDataSource implements ProductLocalDataSource {
  final Isar db;

  ProductIsarDataSource({required this.db});

  @override
  Stream<List<ProductEntity>> getProducts() async* {
    yield* db.productEntitys.where().watch(fireImmediately: true);
  }

  @override
  Future<ProductEntity?> getProductById(String productId) async {
    return await db.productEntitys
        .where()
        .productIdEqualTo(productId)
        .findFirst();
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    await db.writeTxn(() async {
      await db.productEntitys.put(product);
    });
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final existingProduct = await db.productEntitys
        .where()
        .productIdEqualTo(product.productId)
        .findFirst();
    if (existingProduct != null) {
      try {
        await db.writeTxn(() async {
          await db.productEntitys.put(product..isarId = existingProduct.isarId);
        });
      } catch (e) {
        throw AppExceptions.dataExceptions.updateProductEntityException;
      }
    } else {
      throw AppExceptions.dataExceptions.productEntityNotFoundException;
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    final existingProduct = await db.productEntitys
        .where()
        .productIdEqualTo(productId)
        .findFirst();
    if (existingProduct != null) {
      try {
        await db.writeTxn(() async {
          await db.productEntitys.delete(existingProduct.isarId);
        });
      } catch (e) {
        throw Exception('Product not deleted');
      }
    } else {
      throw Exception('Product not found');
    }
  }

  @override
  Future<void> overrideProducts(List<ProductEntity> products) async {
    await db.writeTxn(() async {
      await db.productEntitys.clear();
      await db.productEntitys.putAll(products);
    });
  }
}
