import '../../entities/pos.dart';

abstract class ProductRepository {
  Stream<List<Product>> getProducts();

  Future<void> addProduct({required Product product});

  Future<void> updateProductStock({
    required Product updatedProduct,
    required int deltaStock,
  });

  Future<void> deleteProduct({required String productId});

  Future<Product> getProductById({required String productId});

  Future<void> sync();
  void dispose();

  Future<List<PendingUpdates>> getPendingProductsUpdates();
}
