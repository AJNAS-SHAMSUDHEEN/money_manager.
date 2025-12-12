import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transactions_repository.dart';
import 'add_transaction_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _transactionsRepo = TransactionsRepository();

  @override
  Widget build(BuildContext context) {
    final transactions = _transactionsRepo.getAllTransactions();

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions yet'))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (_, index) {
          final tx = transactions[index];
          return ListTile(
            leading: Icon(
              tx.type == 'income'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: tx.type == 'income' ? Colors.green : Colors.red,
            ),
            title: Text('${tx.amount} ₹'),
            // subtitle: Text(tx.note!.isNotEmpty ? tx.note : tx.type),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _transactionsRepo.deleteTransaction(tx.id);
                setState(() {});
              },
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTransactionPage(transaction: tx),
                ),
              );
              setState(() {}); // Refresh list after editing
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
          setState(() {}); // Refresh list after adding
        },
      ),
    );
  }
}
