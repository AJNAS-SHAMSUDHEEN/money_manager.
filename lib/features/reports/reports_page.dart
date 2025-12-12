import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../data/models/transaction_model.dart';
import '../../data/repositories/transactions_repository.dart';
import '../../data/repositories/categories_repository.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _transactionsRepo = TransactionsRepository();
  final _categoriesRepo = CategoriesRepository();

  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    transactions = _transactionsRepo.getAllTransactions();
  }

  List<PieChartSectionData> _pieSections() {
    final categories = _categoriesRepo.getAllCategories();

    List<PieChartSectionData> sections = [];

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];

      final amount = transactions
          .where((tx) => tx.categoryId == cat.id && tx.type == 'expense')
          .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));

      if (amount <= 0) continue; // skip zero amounts

      sections.add(
        PieChartSectionData(
          value: amount,
          title: cat.name,
          color: Colors.primaries[i % Colors.primaries.length],
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      );
    }

    return sections;
  }


  List<BarChartGroupData> _barGroups() {
    Map<String, double> dailyIncome = {};
    Map<String, double> dailyExpense = {};
    DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final key = DateFormat('EEE').format(day);
      final dayTx = transactions.where((tx) =>
      tx.date.year == day.year && tx.date.month == day.month && tx.date.day == day.day);

      dailyIncome[key] = dayTx.where((tx) => tx.type == 'income').fold(0, (sum, tx) => sum + tx.amount);
      dailyExpense[key] = dayTx.where((tx) => tx.type == 'expense').fold(0, (sum, tx) => sum + tx.amount);
    }

    int x = 0;
    return dailyIncome.entries.map((e) {
      final income = e.value;
      final expense = dailyExpense[e.key] ?? 0;
      return BarChartGroupData(
        x: x++,
        barRods: [
          BarChartRodData(toY: income, color: Colors.green),
          BarChartRodData(toY: expense, color: Colors.red),
        ],
        showingTooltipIndicators: [0, 1],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detailed Reports')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Expense by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _pieSections(),
                  centerSpaceRadius: 30,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Income vs Expense (Last 7 Days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _barGroups(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
