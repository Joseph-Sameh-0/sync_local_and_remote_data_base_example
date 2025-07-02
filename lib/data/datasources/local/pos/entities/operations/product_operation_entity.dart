import 'package:isar/isar.dart';

part 'product_operation_entity.g.dart';

@collection
class ProductOperationEntity {
  Id id = Isar.autoIncrement;

  late String productId;
  @enumerated
  late ProductOperationType operationType;
  String? value;
  late DateTime timestamp;

  ProductOperationEntity({
    required this.productId,
    required this.operationType,
    this.value,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'ProductOperationEntity(id: $id, productId: $productId, operationType: $operationType, value: $value, timestamp: $timestamp)';
  }
}

enum ProductOperationType {
  add,
  updateName,
  updateBarcode,
  updatePrice,
  updateStock,
  delete,
}