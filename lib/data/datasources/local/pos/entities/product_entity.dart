import 'package:isar/isar.dart';

import '../../../../../domain/entities/pos.dart';
import '../../../remote/pos/dtos/product_dto.dart';

part 'product_entity.g.dart';

@collection
class ProductEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String productId;
  late String name;
  late String barcode;
  late double price;
  late int stock;
  late DateTime createdAt;
  late DateTime lastUpdate;

  ProductEntity({
    required this.productId,
    required this.name,
    required this.barcode,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.lastUpdate,
  });

  factory ProductEntity.fromDomain(Product product) {
    return ProductEntity(
      productId: product.productId,
      name: product.name,
      barcode: product.barcode,
      price: product.price,
      stock: product.stock,
      createdAt: product.createdAt,
      lastUpdate: product.lastUpdate,
    );
  }

  Product toDomain() {
    return Product(
      productId: productId,
      name: name,
      barcode: barcode,
      price: price,
      stock: stock,
      createdAt: createdAt,
      lastUpdate: lastUpdate,
    );
  }

  factory ProductEntity.fromDto(ProductDto productDto) {
    return ProductEntity(
      productId: productDto.productId,
      name: productDto.name,
      barcode: productDto.barcode,
      price: productDto.price,
      stock: productDto.stock,
      createdAt: productDto.createdAt,
      lastUpdate: productDto.lastUpdate,
    );
  }

  @override
  String toString() {
    return 'ProductEntity{productId: $productId, name: $name, barcode: $barcode, price: $price, stock: $stock, createdAt: $createdAt, lastUpdate: $lastUpdate}';
  }
}