import '../../../../core/services/firebase_service/firebase_service.dart';
import 'dtos/product_dto.dart';

abstract class ProductRemoteDataSource {
  Stream<List<ProductDto>> getProducts();

  Future<ProductDto?> getProductById(String productId);

  Future<void> addProduct(ProductDto product);

  Future<void> updateProduct(ProductDto product);

  Future<void> deleteProduct(String productId);
}

class ProductFireStoreDataSource implements ProductRemoteDataSource {
  final FirebaseService firebaseService;
  final String productsPath = 'products';

  ProductFireStoreDataSource({required this.firebaseService});

  @override
  Stream<List<ProductDto>> getProducts() {
    return firebaseService.streamCollection(
      path: productsPath,
      fromJson: ProductDto.fromJson,
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<ProductDto?> getProductById(String productId) async {
    return await firebaseService.getDoc<ProductDto>(
      path: '$productsPath/$productId',
      fromJson: ProductDto.fromJson,
    );
  }

  @override
  Future<void> addProduct(ProductDto product) async {
    await firebaseService.addToCollection(
      path: productsPath,
      data: product.toJson(),
    );
  }

  @override
  Future<void> updateProduct(ProductDto product) async {
    await firebaseService.updateDoc(
      path: '$productsPath/${product.productId}',
      data: product.toJson(),
    );
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await firebaseService.deleteDoc(path: '$productsPath/$productId');
  }
}
