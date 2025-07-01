import 'package:isar/isar.dart';

import '../../../../../domain/entities/pos.dart';
import '../../../remote/pos/dtos/transaction_item_dto.dart';

part 'transaction_item_entity.g.dart';

@collection
class TransactionItemEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String itemId;

  @Index()
  late String transactionId;
  late String productId;
  late String productName;
  late double productPrice;
  late int quantity;
  late double subtotal;
  late DateTime lastUpdate;

  TransactionItemEntity({
    required this.itemId,
    required this.transactionId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.subtotal,
    required this.lastUpdate,
  });

  factory TransactionItemEntity.fromDomain(TransactionItem item) {
    return TransactionItemEntity(
      itemId: item.itemId,
      transactionId: item.transactionId,
      productId: item.productId,
      productName: item.productName,
      productPrice: item.productPrice,
      quantity: item.quantity,
      subtotal: item.productPrice * item.quantity,
      lastUpdate: DateTime.now(),
    );
  }

  TransactionItem toDomain() {
    return TransactionItem(
      itemId: itemId,
      productId: productId,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity,
      subtotal: subtotal,
      lastUpdate: lastUpdate,
      transactionId: transactionId,
    );
  }

  factory TransactionItemEntity.fromDto(TransactionItemDto itemDto) {
    return TransactionItemEntity(
      itemId: itemDto.itemId,
      transactionId: itemDto.transactionId,
      productId: itemDto.productId,
      productName: itemDto.productName,
      productPrice: itemDto.productPrice,
      quantity: itemDto.quantity,
      subtotal: itemDto.subtotal,
      lastUpdate: itemDto.lastUpdate,
    );
  }

  @override
  String toString() {
    return 'TransactionItemEntity{ transactionId: $transactionId, productId: $productId, productName: $productName, productPrice: $productPrice, quantity: $quantity, subtotal: $subtotal, lastUpdate: $lastUpdate}';
  }
}
