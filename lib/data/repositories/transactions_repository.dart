import '../models/transaction_model.dart';

class TransactionsRepository {
  // Singleton instance
  static final TransactionsRepository _instance = TransactionsRepository._internal();
  factory TransactionsRepository() => _instance;
  TransactionsRepository._internal();

  final List<TransactionModel> _transactions = [];

  List<TransactionModel> getAllTransactions() => _transactions;

  void addTransaction(TransactionModel tx) {
    _transactions.add(tx); // don't overwrite ID
  }

  void updateTransaction(String id, TransactionModel tx) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) _transactions[index] = tx;
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
  }
}
