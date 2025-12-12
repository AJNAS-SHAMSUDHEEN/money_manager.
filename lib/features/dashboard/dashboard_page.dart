import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/transaction_model.dart';
import '../../data/repositories/transactions_repository.dart';
import '../../features/reports/reports_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _transactionsRepo = TransactionsRepository();

  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _calculateSummary();
  }

  void _calculateSummary() {
    final txList = _transactionsRepo.getAllTransactions();

    totalIncome = txList.where((tx) => tx.type == 'income').fold(0, (sum, tx) => sum + tx.amount);
    totalExpense = txList.where((tx) => tx.type == 'expense').fold(0, (sum, tx) => sum + tx.amount);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards
            Card(
              child: ListTile(
                  title: const Text('Total Income'),
                  trailing: Text('₹${totalIncome.toStringAsFixed(2)}')),
            ),
            Card(
              child: ListTile(
                  title: const Text('Total Expense'),
                  trailing: Text('₹${totalExpense.toStringAsFixed(2)}')),
            ),
            Card(
              child: ListTile(
                  title: const Text('Balance'),
                  trailing: Text('₹${(totalIncome - totalExpense).toStringAsFixed(2)}')),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsPage()),
                );
              },
              icon: const Icon(Icons.bar_chart),
              label: const Text('View Detailed Reports'),
            ),
          ],
        ),
      ),
    );
  }
}
