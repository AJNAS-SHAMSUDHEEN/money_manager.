import 'package:hive/hive.dart';
import '../models/category_model.dart';

class CategoriesRepository {
  final Box<CategoryModel> _box = Hive.box<CategoryModel>('categories');

  List<CategoryModel> getAllCategories() {
    return _box.values.toList();
  }

  CategoryModel? getById(String id) {
    try {
      return _box.values.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  List<CategoryModel> getCategoriesByType(String type) {
    return _box.values.where((c) => c.type == type).toList();
  }

  void addCategory(CategoryModel category) {
    _box.put(category.id, category);
  }

  void deleteCategory(String id) {
    _box.delete(id);
  }
}
