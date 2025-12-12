import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id; // 👈 Added unique id for transactions

  @HiveField(1)
  double amount;

  @HiveField(2)
  String categoryId; // reference to CategoryModel.id

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String type; // "income" or "expense"

  @HiveField(5)
  String? note;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.type,
    this.note,
  });
}
