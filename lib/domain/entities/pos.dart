class Product {
  final String productId;
  final String name;
  final String barcode;
  final double price;
  final int stock;
  final DateTime createdAt;
  final DateTime lastUpdate;

  Product({
    required this.productId,
    required this.name,
    required this.barcode,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.lastUpdate,
  });

  Product copyWith({
    String? productId,
    String? name,
    String? barcode,
    double? price,
    int? stock,
    DateTime? createdAt,
    DateTime? lastUpdate,
  }) {
    return Product(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  toJson() {
    return {
      'productId': productId,
      'name': name,
      'barcode': barcode,
      'price': price,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  static fromJson(Map<String, dynamic> map) {
    return Product(
      productId: map['productId'] as String,
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      price: map['price'] as double,
      stock: map['stock'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdate: DateTime.parse(map['lastUpdate'] as String),
    );
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Transaction {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final DateTime lastUpdate;

  Transaction({
    required this.id,
    required this.createdAt,
    required this.total,
    required this.items,
    required this.lastUpdate,
  });

  Transaction copyWith({
    String? id,
    DateTime? createdAt,
    List<CartItem>? items,
    double? total,
    DateTime? lastUpdate,
  }) {
    return Transaction(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      total: total ?? this.total,
      items: items ?? this.items,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'total': total,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  static fromJson (Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      total: map['total'] as double,
      lastUpdate: DateTime.parse(map['lastUpdate'] as String),
      items: [],
    );
  }
}

class TransactionItem {
  final String itemId;
  final String transactionId;
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;
  final double subtotal;
  final DateTime lastUpdate;


  TransactionItem({
    required this.itemId,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.productPrice,
    required this.subtotal,
    required this.lastUpdate,
  });

  toJson() {
    return {
      'itemId': itemId,
      'transactionId': transactionId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'subtotal': subtotal,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  static fromJson(Map<String, dynamic> map) {
    return TransactionItem(
      itemId: map['itemId'] as String,
      transactionId: map['transactionId'] as String,
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as double,
      quantity: map['quantity'] as int,
      subtotal: map['subtotal'] as double,
      lastUpdate: DateTime.parse(map['lastUpdate'] as String),
    );
  }
}

class PendingUpdates {
  final String id;
  final String action;
  final Map<String, dynamic> changes;
  final DateTime timestamp;

  PendingUpdates({
    required this.id,
    required this.action,
    required this.changes,
    required this.timestamp,
  });
}