import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_local_and_remote_data_base_example/domain/repositories/pos/product_repository.dart';
import 'package:uuid/uuid.dart';

import '../../di/injection_container.dart';
import '../../domain/entities/pos.dart';
import '../../domain/usecases/base_use_case.dart';
import '../../domain/usecases/pos_usecases.dart';
import 'pos_state.dart';

class POSCubit extends Cubit<POSState> {
  final GetProductsUseCase getProducts;
  final ProcessSaleUseCase processSale;
  final SearchProductsUseCase searchProductsUseCase;
  final AddProductUseCase addProductUseCase;
  StreamSubscription? _productsSubscription;

  POSCubit({
    required this.getProducts,
    required this.processSale,
    required this.searchProductsUseCase,
    required this.addProductUseCase,
  }) : super(POSInitial());

  void loadProducts() async {
    emit(POSLoading());
    _productsSubscription?.cancel();
    _productsSubscription = getProducts(NoParams()).listen(
      (products) {
        final currentState = state;
        if (currentState is POSLoaded) {
          emit(currentState.copyWith(products: products));
        } else {
          emit(POSLoaded(products: products, cart: []));
        }
      },
      onError: (error) {
        emit(POSError(error.toString()));
      },
    );
  }

  Future<void> search(String query) async {
    try {
      final currentState = state;
      if (currentState is POSLoaded) {
        final filteredProducts = await searchProductsUseCase(
          SearchParams(products: currentState.products, query: query),
        );
        emit(currentState.copyWith(filteredProducts: filteredProducts));
      } else {
        emit(POSError('Cannot search: products not loaded.'));
      }
    } catch (e) {
      emit(POSError(e.toString()));
      return;
    }
  }

  Future<void> addItemToCart(Product product) async {
    try {
      final currentState = state;
      if (currentState is POSLoaded) {
        bool isItemExist = true;
        final existingItem = currentState.cart.firstWhere(
          (item) => item.product.productId == product.productId,
          orElse: () {
            isItemExist = false;
            return CartItem(product: product, quantity: 0);
          },
        );
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
        final updatedCart = List<CartItem>.from(currentState.cart);

        if (isItemExist) {
          updatedCart[updatedCart.indexOf(existingItem)] = updatedItem;
        } else {
          updatedCart.add(updatedItem);
        }
        emit(currentState.copyWith(cart: updatedCart));
      } else {
        emit(POSError('Cannot add item: products not loaded.'));
      }
    } catch (e) {
      emit(POSError(e.toString()));
      return;
    }
  }

  void removeItemFromCart(String productId) {
    try {
      final currentState = state;
      if (currentState is POSLoaded) {
        final cart = List<CartItem>.from(currentState.cart);
        final index = cart.indexWhere(
          (item) => item.product.productId == productId,
        );
        if (index != -1) {
          final item = cart[index];
          // if (item.quantity > 1) {
            cart[index] = item.copyWith(quantity: item.quantity - 1);
          // } else {
          //   cart.removeAt(index);
          // }
          emit(currentState.copyWith(cart: cart));
        }
      } else {
        emit(POSError('Cannot remove item: products not loaded.'));
      }
    } catch (e) {
      emit(POSError(e.toString()));
    }
  }

  Future<void> checkout() async {
    final currentState = state;
    try {
      if (currentState is POSLoaded) {
        List<CartItem> cart = currentState.cart;
        emit(currentState.copyWith(cart: []));
        await processSale(cart);
      } else {
        emit(POSError('Cannot checkout: products not loaded.'));
      }
    } catch (e) {
      emit(POSError(e.toString()));
      return;
    }
  }

  void addNewProduct({required String name, required String barcode, required double price, required int stock}) {
    final newProduct = Product(
      productId: Uuid().v4(),
      name: name,
      barcode: barcode,
      price: price,
      stock: stock,
      createdAt: DateTime.now(),
      lastUpdate: DateTime.now(),
    );

    addProductUseCase(newProduct).catchError((error) {
      emit(POSError(error.toString()));
    });
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}