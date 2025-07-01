import 'package:uuid/uuid.dart';

import '../entities/pos.dart';
import '../repositories/pos/product_repository.dart';
import '../repositories/pos/transaction_repository.dart';
import 'base_use_case.dart';

class GetProductsUseCase extends StreamUseCase<List<Product>, NoParams> {
  final ProductRepository productRepository;

  GetProductsUseCase({required this.productRepository});

  @override
  Stream<List<Product>> call(NoParams params) {
    return productRepository.getProducts();
  }
}

class SearchProductsUseCase extends UseCase<List<Product>, SearchParams> {
  @override
  Future<List<Product>> call(SearchParams cartItems) async {
    return cartItems.products
        .where(
          (product) =>
              product.name.toLowerCase().contains(
                cartItems.query.toLowerCase(),
              ) ||
              product.barcode.toLowerCase().contains(
                cartItems.query.toLowerCase(),
              ),
        )
        .toList();
  }
}

class SearchParams {
  final List<Product> products;
  final String query;

  SearchParams({required this.products, required this.query});
}

class ProcessSaleUseCase extends UseCase<void, List<CartItem>> {
  final ProductRepository productRepository;
  final TransactionRepository transactionRepository;

  ProcessSaleUseCase({
    required this.productRepository,
    required this.transactionRepository,
  });

  @override
  Future<void> call(List<CartItem> cartItems) async {
    Transaction transaction = Transaction(
      id: Uuid().v4(),
      createdAt: DateTime.now(),
      items: cartItems,
      total: cartItems.fold(
        0.0,
        (sum, item) => sum + (item.product.price * item.quantity),
      ),
      lastUpdate: DateTime.now(),
    );
    String transactionId = await transactionRepository.addTransaction(transaction);

    for (final item in cartItems) {
      await transactionRepository.addTransactionItem(
        transactionItem: TransactionItem(
          itemId: Uuid().v4(),
          transactionId: transactionId,
          productId: item.product.productId,
          quantity: item.quantity,
          productPrice: item.product.price,
          productName: item.product.name,
          subtotal: item.product.price * item.quantity,
          lastUpdate: DateTime.now(),
        ),
      );

      await productRepository.updateProductStock(
        updatedProduct: item.product.copyWith(
          stock: item.product.stock - item.quantity,
        ),
        deltaStock: -item.quantity,
      );
    }
  }
}

class AddProductUseCase extends UseCase<void, Product> {
  final ProductRepository productRepository;

  AddProductUseCase({required this.productRepository});

  @override
  Future<void> call(Product product) async {
    await productRepository.addProduct(product: product);
  }
}
