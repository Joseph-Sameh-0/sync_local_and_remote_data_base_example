
import '../../../../../domain/entities/pos.dart';

class ProductDto {
  final String productId;
  final String name;
  final String barcode;
  final double price;
  final int stock;
  final DateTime createdAt;
  final DateTime lastUpdate;

  ProductDto({
    required this.productId,
    required this.name,
    required this.barcode,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.lastUpdate,
  });

  static ProductDto fromDomain(Product product) {
    return ProductDto(
      productId: product.productId,
      name: product.name,
      barcode: product.barcode,
      price: product.price,
      stock: product.stock,
      createdAt: product.createdAt,
      lastUpdate: product.lastUpdate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'barcode': barcode,
      'price': price,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory ProductDto.fromJson(Map<String, dynamic> map, String id) {
    return ProductDto(
      productId: id,
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      price: map['price'] as double,
      stock: map['stock'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdate: DateTime.parse(map['lastUpdate'] as String),
    );
  }

  ProductDto copyWith ({
    String? productId,
    String? name,
    String? barcode,
    double? price,
    int? stock,
    DateTime? createdAt,
    DateTime? lastUpdate,
  }) {
    return ProductDto(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}