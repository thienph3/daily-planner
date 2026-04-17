import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../models/book.dart';
import '../models/book_category.dart';
import '../providers/book_provider.dart';

/// Màn hình quản lý sách
class BookScreen extends ConsumerStatefulWidget {
  const BookScreen({super.key});

  @override
  ConsumerState<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final allBooks = ref.watch(bookProvider);
    final categories = ref.watch(bookCategoryProvider);

    final books = (_selectedCategoryId == null
        ? allBooks
        : allBooks.where((b) => b.categoryId == _selectedCategoryId).toList())
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('📖 Quản lý sách'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Danh mục sách',
            onPressed: () => _showCategoryManager(context, ref, categories),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      body: Column(
        children: [
          if (categories.isNotEmpty)
            _buildCategoryChips(categories),
          Expanded(
            child: books.isEmpty
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
                        index: index + 1,
                        book: book,
                        categoryName:
                            cat != null ? '${cat.emoji} ${cat.name}' : null,
                        onToggleRead: () =>
                            ref.read(bookProvider.notifier).toggleRead(book.id),
                        onEdit: () =>
                            _editBook(context, ref, book, categories),
                        onDelete: () => _deleteBook(context, ref, book),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addBook(context, ref, categories),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryChips(List<BookCategory> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingStandard,
        vertical: AppSpacing.gapItem,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Tất cả'),
              selected: _selectedCategoryId == null,
              onSelected: (_) => setState(() => _selectedCategoryId = null),
              selectedColor: AppColors.primary.withValues(alpha: 0.3),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusButton),
                side: BorderSide(
                  color: _selectedCategoryId == null
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          ...categories.map((cat) {
            final isSelected = _selectedCategoryId == cat.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text('${cat.emoji} ${cat.name}'),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => _selectedCategoryId = isSelected ? null : cat.id),
                selectedColor: AppColors.primary.withValues(alpha: 0.3),
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusButton),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _addBook(BuildContext context, WidgetRef ref,
      List<BookCategory> categories) async {
    final result = await _showBookDialog(context, categories);
    if (result != null) {
      await ref.read(bookProvider.notifier).add(
            title: result['title'] as String,
            categoryId: result['categoryId'] as String? ?? '',
            isPaperBook: result['isPaperBook'] as bool? ?? false,
            isEbook: result['isEbook'] as bool? ?? false,
          );
    }
  }

  Future<void> _editBook(BuildContext context, WidgetRef ref, Book book,
      List<BookCategory> categories) async {
    final result = await _showBookDialog(context, categories,
        title: book.title,
        categoryId: book.categoryId,
        isPaperBook: book.isPaperBook,
        isEbook: book.isEbook);
    if (result != null) {
      await ref.read(bookProvider.notifier).update(
            book.copyWith(
              title: result['title'] as String,
              categoryId: result['categoryId'] as String,
              isPaperBook: result['isPaperBook'] as bool,
              isEbook: result['isEbook'] as bool,
            ),
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

  Future<Map<String, dynamic>?> _showBookDialog(
    BuildContext context,
    List<BookCategory> categories, {
    String title = '',
    String categoryId = '',
    bool isPaperBook = false,
    bool isEbook = false,
  }) {
    final titleController = TextEditingController(text: title);
    final formKey = GlobalKey<FormState>();
    String selectedCategoryId = categoryId;
    bool paper = isPaperBook;
    bool ebook = isEbook;

    return showDialog<Map<String, dynamic>>(
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
                const SizedBox(height: AppSpacing.gapItem),
                CheckboxListTile(
                  value: paper,
                  onChanged: (v) => setDialogState(() => paper = v ?? false),
                  title: const Text('📄 Sách giấy'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  value: ebook,
                  onChanged: (v) => setDialogState(() => ebook = v ?? false),
                  title: const Text('📱 Ebook'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
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
                  'isPaperBook': paper,
                  'isEbook': ebook,
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
  final int index;
  final Book book;
  final String? categoryName;
  final VoidCallback onToggleRead;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BookCard({
    required this.index,
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
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$index',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onToggleRead,
              child: Icon(
                book.isRead ? Icons.check_circle : Icons.circle_outlined,
                color: book.isRead ? AppColors.success : AppColors.textSecondary,
                size: 28,
              ),
            ),
          ],
        ),
        title: Text(
          book.title,
          style: TextStyle(
            decoration: book.isRead ? TextDecoration.lineThrough : null,
            color: book.isRead ? AppColors.textSecondary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: _buildSubtitle(),
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

  Widget? _buildSubtitle() {
    final parts = <String>[];
    if (categoryName != null) parts.add(categoryName!);
    if (book.isPaperBook) parts.add('📄 Sách giấy');
    if (book.isEbook) parts.add('📱 Ebook');
    if (parts.isEmpty) return null;
    return Text(
      parts.join('  ·  '),
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
