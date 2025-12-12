import 'package:hive/hive.dart';
import '../models/budget_model.dart';

class BudgetRepository {
  final Box<BudgetModel> _box = Hive.box<BudgetModel>('budgets');

  Future<void> setBudget(BudgetModel budget) async {
    // Replace existing budget for same month & year
    final existing = _box.values.where((b) => b.year == budget.year && b.month == budget.month).toList();
    if (existing.isNotEmpty) {
      await existing.first.delete();
    }
    await _box.add(budget);
  }

  BudgetModel? getBudget(int year, int month) {
    try {
      return _box.values.firstWhere(
            (b) => b.year == year && b.month == month,
      );
    } catch (e) {
      // Not found
      return null;
    }
  }

}
