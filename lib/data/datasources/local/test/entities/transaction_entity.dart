// import 'package:isar/isar.dart';
//
// import '../../../../../domain/entities/transaction.dart';
// import '../../../remote/test/dtos/transaction_dto.dart';
//
//
// @collection
// class TransactionEntity {
//   Id isarId = Isar.autoIncrement;
//
//   @Index(unique: true)
//   late String id;
//
//   late String title;
//   late int amount;
//   late DateTime createdAt;
//   late DateTime lastUpdate;
//
//   TransactionEntity({
//     required this.id,
//     required this.title,
//     required this.amount,
//     required this.createdAt,
//     required this.lastUpdate,
//   });
//
//   factory TransactionEntity.fromDomain(Transaction todo) {
//     return TransactionEntity(
//       id: todo.id,
//       title: todo.title,
//       amount: todo.amount,
//       createdAt: todo.createdAt,
//       lastUpdate: todo.lastUpdate,
//     );
//   }
//
//   Transaction toDomain() {
//     return Transaction(
//       id: id,
//       title: title,
//       amount: amount,
//       createdAt: createdAt,
//       lastUpdate: lastUpdate,
//     );
//   }
//
//   factory TransactionEntity.fromDto(TransactionDto todoDto) {
//     return TransactionEntity(
//       id: todoDto.id,
//       title: todoDto.title,
//       amount: todoDto.amount,
//       createdAt: todoDto.createdAt,
//       lastUpdate: todoDto.lastUpdate,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'TransactionEntity{id: $id, title: $title, amount: $amount, createdAt: $createdAt, lastUpdate: $lastUpdate}';
//   }
// }
