import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../models/book.dart';
import '../models/book_category.dart';
import '../providers/book_provider.dart';

/// Màn hình quản lý sách
class BookScreen extends ConsumerWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(bookProvider);
    final categories = ref.watch(bookCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📖 Quản lý sách'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Danh mục sách',
            onPressed: () => _showCategoryManager(context, ref, categories),
          ),
        ],
      ),
      body: books.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.menu_book_outlined,
              title: 'Chưa có sách nào',
              subtitle: 'Thêm sách bạn muốn đọc nhé 📚',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.paddingStandard),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final cat = categories
                    .where((c) => c.id == book.categoryId)
                    .firstOrNull;
                return _BookCard(
                  book: book,
                  categoryName: cat != null ? '${cat.emoji} ${cat.name}' : null,
                  onToggleRead: () =>
                      ref.read(bookProvider.notifier).toggleRead(book.id),
                  onEdit: () =>
                      _editBook(context, ref, book, categories),
                  onDelete: () =>
                      _deleteBook(context, ref, book),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addBook(context, ref, categories),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addBook(BuildContext context, WidgetRef ref,
      List<BookCategory> categories) async {
    final result = await _showBookDialog(context, categories);
    if (result != null) {
      await ref.read(bookProvider.notifier).add(
            title: result['title']!,
            categoryId: result['categoryId'] ?? '',
          );
    }
  }

  Future<void> _editBook(BuildContext context, WidgetRef ref, Book book,
      List<BookCategory> categories) async {
    final result = await _showBookDialog(context, categories,
        title: book.title, categoryId: book.categoryId);
    if (result != null) {
      await ref.read(bookProvider.notifier).update(
            book.copyWith(
                title: result['title'], categoryId: result['categoryId']),
          );
    }
  }

  Future<void> _deleteBook(
      BuildContext context, WidgetRef ref, Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: const Text('Xóa sách?'),
        content: Text('Bạn có chắc muốn xóa "${book.title}"?'),
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
      await ref.read(bookProvider.notifier).delete(book.id);
    }
  }

  Future<Map<String, String>?> _showBookDialog(
    BuildContext context,
    List<BookCategory> categories, {
    String title = '',
    String categoryId = '',
  }) {
    final titleController = TextEditingController(text: title);
    final formKey = GlobalKey<FormState>();
    String selectedCategoryId = categoryId;

    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
          title:
              Text(title.isEmpty ? 'Thêm sách ✨' : 'Sửa sách ✏️'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Tên sách *'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Không được để trống'
                      : null,
                ),
                const SizedBox(height: AppSpacing.gapItem),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId.isEmpty
                      ? null
                      : selectedCategoryId,
                  decoration:
                      const InputDecoration(labelText: 'Danh mục sách'),
                  items: [
                    const DropdownMenuItem(
                        value: '', child: Text('Không có danh mục')),
                    ...categories.map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text('${c.emoji} ${c.name}'),
                        )),
                  ],
                  onChanged: (v) =>
                      setDialogState(() => selectedCategoryId = v ?? ''),
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
                  'title': titleController.text.trim(),
                  'categoryId': selectedCategoryId,
                });
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryManager(BuildContext context, WidgetRef ref,
      List<BookCategory> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _BookCategorySheet(),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final String? categoryName;
  final VoidCallback onToggleRead;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BookCard({
    required this.book,
    this.categoryName,
    required this.onToggleRead,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.gapItem),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingStandard, vertical: 4),
        leading: GestureDetector(
          onTap: onToggleRead,
          child: Icon(
            book.isRead ? Icons.check_circle : Icons.circle_outlined,
            color: book.isRead ? AppColors.success : AppColors.textSecondary,
            size: 28,
          ),
        ),
        title: Text(
          book.title,
          style: TextStyle(
            decoration: book.isRead ? TextDecoration.lineThrough : null,
            color: book.isRead ? AppColors.textSecondary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: categoryName != null
            ? Text(categoryName!,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12))
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit') onEdit();
            if (v == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Sửa')),
            const PopupMenuItem(value: 'delete', child: Text('Xóa')),
          ],
        ),
      ),
    );
  }
}

class _BookCategorySheet extends ConsumerWidget {
  const _BookCategorySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(bookCategoryProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingStandard),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('📂 Danh mục sách',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _addCategory(context, ref),
                ),
              ],
            ),
          ),
          Expanded(
            child: categories.isEmpty
                ? const Center(child: Text('Chưa có danh mục nào'))
                : ListView.builder(
                    controller: scrollController,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return ListTile(
                        leading:
                            Text(cat.emoji, style: const TextStyle(fontSize: 24)),
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
                                  color: AppColors.error, size: 20),
                              onPressed: () => ref
                                  .read(bookCategoryProvider.notifier)
                                  .delete(cat.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final result = await _showCategoryDialog(context, title: 'Thêm danh mục sách');
    if (result != null && result.trim().isNotEmpty) {
      await ref.read(bookCategoryProvider.notifier).add(name: result);
    }
  }

  Future<void> _editCategory(BuildContext context, WidgetRef ref, BookCategory cat) async {
    final result = await _showCategoryDialog(
      context,
      title: 'Sửa danh mục sách',
      initialName: cat.name,
    );
    if (result != null && result.trim().isNotEmpty) {
      await ref
          .read(bookCategoryProvider.notifier)
          .update(cat.copyWith(name: result.trim()));
    }
  }

  Future<String?> _showCategoryDialog(
    BuildContext context, {
    required String title,
    String initialName = '',
  }) {
    final nameController = TextEditingController(text: initialName);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Tên danh mục'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
