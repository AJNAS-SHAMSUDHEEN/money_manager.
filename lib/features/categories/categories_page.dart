import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/categories_repository.dart';
import 'add_category_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _categoriesRepo = CategoriesRepository();
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = _categoriesRepo.getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: _categories.isEmpty
          ? const Center(child: Text('No categories yet'))
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return ListTile(
            leading: Icon(
              cat.type == 'income'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: cat.type == 'income' ? Colors.green : Colors.red,
            ),
            title: Text(cat.name),
            subtitle: Text(cat.type),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _categoriesRepo.deleteCategory(cat.id);
                  _loadCategories();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCategoryPage()),
          );
          _loadCategories();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
