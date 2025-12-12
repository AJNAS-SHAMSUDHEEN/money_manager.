import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/transactions_repository.dart';
import '../../data/repositories/categories_repository.dart';

class AddTransactionPage extends StatefulWidget {
  final TransactionModel? transaction; // optional for editing

  const AddTransactionPage({super.key, this.transaction});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'expense';
  CategoryModel? _selectedCategory;

  final _transactionsRepo = TransactionsRepository();
  final _categoriesRepo = CategoriesRepository();

  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      _type = widget.transaction!.type;
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction?.note ?? '';
    }

    _loadCategories();

    if (widget.transaction != null) {
      _selectedCategory =
          _categoriesRepo.getById(widget.transaction!.categoryId);
    }
  }

  void _loadCategories() {
    final cats = _categoriesRepo.getCategoriesByType(_type);
    setState(() {
      _categories = cats;
      _selectedCategory = cats.isNotEmpty ? cats.first : null;
    });
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final tx = TransactionModel(
        id: widget.transaction?.id ?? const Uuid().v4(), // ✅ fix
        amount: double.parse(_amountController.text),
        categoryId: _selectedCategory!.id,
        date: DateTime.now(),
        type: _type,
        note: _noteController.text,
      );

      if (widget.transaction == null) {
        _transactionsRepo.addTransaction(tx);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added ✅')),
        );
      } else {
        _transactionsRepo.updateTransaction(tx.id, tx);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction updated ✅')),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.transaction == null ? 'Add Transaction' : 'Edit Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (val) {
                  setState(() {
                    _type = val!;
                    _loadCategories();
                  });
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<CategoryModel>(
                value: _categories.isNotEmpty ? _selectedCategory : null,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat.name),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (val) =>
                val == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noteController,
                decoration:
                const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(widget.transaction == null ? 'Save' : 'Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
