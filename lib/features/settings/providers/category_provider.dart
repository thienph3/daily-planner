import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../models/category.dart';

const _uuid = Uuid();

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super(const []) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    final box = await HiveHelper.openBox<Category>(HiveHelper.categoryBox);
    state = box.values.toList();
  }

  Future<void> addCategory({required String name, String emoji = '📁'}) async {
    if (name.trim().isEmpty) return;
    final box = await HiveHelper.openBox<Category>(HiveHelper.categoryBox);
    final category = Category(id: _uuid.v4(), name: name.trim(), emoji: emoji);
    await box.put(category.id, category);
    state = [...state, category];
  }

  Future<void> updateCategory(Category updated) async {
    final box = await HiveHelper.openBox<Category>(HiveHelper.categoryBox);
    if (!box.containsKey(updated.id)) return;
    await box.put(updated.id, updated);
    state = state.map((c) => c.id == updated.id ? updated : c).toList();
  }

  Future<void> deleteCategory(String id) async {
    final box = await HiveHelper.openBox<Category>(HiveHelper.categoryBox);
    await box.delete(id);
    state = state.where((c) => c.id != id).toList();
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  return CategoryNotifier();
});
