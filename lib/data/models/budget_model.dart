import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 3)
class BudgetModel extends HiveObject {
  @HiveField(0)
  int year;

  @HiveField(1)
  int month;

  @HiveField(2)
  double amount;

  BudgetModel({
    required this.year,
    required this.month,
    required this.amount,
  });
}
