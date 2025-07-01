import 'package:equatable/equatable.dart';

import '../../domain/entities/pos.dart';

abstract class POSState extends Equatable {
  const POSState();
}

class POSInitial extends POSState {
  @override
  List<Object> get props => [];
}

class POSLoading extends POSState {
  @override
  List<Object> get props => [];
}

class POSLoaded extends POSState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<CartItem> cart;

  const POSLoaded({
    required this.products,
    this.filteredProducts = const [],
    this.cart = const [],
  });

  POSLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    List<CartItem>? cart,
  }) {
    return POSLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      cart: cart ?? this.cart,
    );
  }

  @override
  List<Object> get props => [products, filteredProducts, cart];
}

class POSError extends POSState {
  final String message;

  const POSError(this.message);

  @override
  List<Object> get props => [message];
}
