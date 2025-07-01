import '../../../../../domain/entities/pos.dart';

class TransactionItemDto {
  final String itemId;
  final String transactionId;
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;
  final double subtotal;
  final DateTime lastUpdate;


  TransactionItemDto({
    required this.itemId,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.productPrice,
    required this.subtotal,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'productId': productId,
      'quantity': quantity,
      'productName': productName,
      'productPrice': productPrice,
      'subtotal': subtotal,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory TransactionItemDto.fromJson(Map<String, dynamic> json, String id) {
    return TransactionItemDto(
      itemId: id,
      transactionId: json['transactionId'],
      productId: json['productId'],
      quantity: json['quantity'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      subtotal: json['subtotal'],
      lastUpdate: DateTime.parse(json['lastUpdate']),
    );
  }

  static TransactionItemDto fromDomain(TransactionItem transaction) {
    return TransactionItemDto(
      itemId: transaction.itemId,
      transactionId: transaction.transactionId,
      productId: transaction.productId,
      quantity: transaction.quantity,
      productName: transaction.productName,
      productPrice: transaction.productPrice,
      subtotal: transaction.subtotal,
      lastUpdate: transaction.lastUpdate,
    );
  }

  TransactionItemDto copyWith ({
    String? itemId,
    String? transactionId,
    String? productId,
    String? productName,
    double? productPrice,
    int? quantity,
    double? subtotal,
    DateTime? lastUpdate,
  }) {
    return TransactionItemDto(
      itemId: itemId ?? this.itemId,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      subtotal: subtotal ?? this.subtotal,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}