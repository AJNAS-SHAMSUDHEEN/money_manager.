import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/categories_repository.dart';
import 'package:uuid/uuid.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _type = 'expense';

  final _categoriesRepo = CategoriesRepository();

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final cat = CategoryModel(
        id: const Uuid().v4(), // removed 'const'
        name: _nameController.text,
        type: _type,
      );

      _categoriesRepo.addCategory(cat);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added ✅')),
      );

      Navigator.pop(context, cat); // return the new category to previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
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
                  });
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCategory,
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
