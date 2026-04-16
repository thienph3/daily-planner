import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';

/// Màn hình quản lý danh mục task
class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('📂 Quản lý danh mục')),
      body: categories.isEmpty
          ? Center(
              child: Text(
                'Chưa có danh mục nào\nHãy thêm danh mục mới 🌸',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.paddingStandard),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.gapItem),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: ListTile(
                    leading: Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                    title: Text(cat.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => _editCategory(context, ref, cat),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              size: 20, color: AppColors.error),
                          onPressed: () => _deleteCategory(context, ref, cat),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCategory(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final result = await _showCategoryDialog(context);
    if (result != null) {
      await ref
          .read(categoryProvider.notifier)
          .addCategory(name: result['name']!, emoji: result['emoji']!);
    }
  }

  Future<void> _editCategory(
      BuildContext context, WidgetRef ref, Category cat) async {
    final result =
        await _showCategoryDialog(context, name: cat.name, emoji: cat.emoji);
    if (result != null) {
      await ref
          .read(categoryProvider.notifier)
          .updateCategory(cat.copyWith(name: result['name'], emoji: result['emoji']));
    }
  }

  Future<void> _deleteCategory(
      BuildContext context, WidgetRef ref, Category cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: const Text('Xóa danh mục?'),
        content: Text('Bạn có chắc muốn xóa "${cat.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Xóa')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(categoryProvider.notifier).deleteCategory(cat.id);
    }
  }

  Future<Map<String, String>?> _showCategoryDialog(
    BuildContext context, {
    String name = '',
    String emoji = '📁',
  }) {
    final nameController = TextEditingController(text: name);
    final emojiController = TextEditingController(text: emoji);
    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: Text(name.isEmpty ? 'Thêm danh mục ✨' : 'Sửa danh mục ✏️'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emojiController,
                decoration: const InputDecoration(labelText: 'Emoji'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: AppSpacing.gapItem),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên danh mục *'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Không được để trống' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'emoji': emojiController.text.trim().isEmpty
                    ? '📁'
                    : emojiController.text.trim(),
              });
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
