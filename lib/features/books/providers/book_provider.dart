import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../models/book.dart';
import '../models/book_category.dart';

const _uuid = Uuid();

/// Provider quản lý danh mục sách
class BookCategoryNotifier extends StateNotifier<List<BookCategory>> {
  BookCategoryNotifier() : super(const []) {
    load();
  }

  Future<void> load() async {
    final box =
        await HiveHelper.openBox<BookCategory>(HiveHelper.bookCategoryBox);
    state = box.values.toList();
  }

  Future<void> add({required String name, String emoji = '📚'}) async {
    if (name.trim().isEmpty) return;
    final box =
        await HiveHelper.openBox<BookCategory>(HiveHelper.bookCategoryBox);
    final cat = BookCategory(id: _uuid.v4(), name: name.trim(), emoji: emoji);
    await box.put(cat.id, cat);
    state = [...state, cat];
  }

  Future<void> update(BookCategory updated) async {
    final box =
        await HiveHelper.openBox<BookCategory>(HiveHelper.bookCategoryBox);
    if (!box.containsKey(updated.id)) return;
    await box.put(updated.id, updated);
    state = state.map((c) => c.id == updated.id ? updated : c).toList();
  }

  Future<void> delete(String id) async {
    final box =
        await HiveHelper.openBox<BookCategory>(HiveHelper.bookCategoryBox);
    await box.delete(id);
    state = state.where((c) => c.id != id).toList();
  }
}

final bookCategoryProvider =
    StateNotifierProvider<BookCategoryNotifier, List<BookCategory>>((ref) {
  return BookCategoryNotifier();
});

/// Provider quản lý sách
class BookNotifier extends StateNotifier<List<Book>> {
  BookNotifier() : super(const []) {
    load();
  }

  Future<void> load() async {
    final box = await HiveHelper.openBox<Book>(HiveHelper.bookBox);
    state = box.values.toList();
  }

  Future<void> add({
    required String title,
    String categoryId = '',
    bool isRead = false,
  }) async {
    if (title.trim().isEmpty) return;
    final box = await HiveHelper.openBox<Book>(HiveHelper.bookBox);
    final book = Book(
      id: _uuid.v4(),
      title: title.trim(),
      categoryId: categoryId,
      isRead: isRead,
    );
    await box.put(book.id, book);
    state = [...state, book];
  }

  Future<void> update(Book updated) async {
    final box = await HiveHelper.openBox<Book>(HiveHelper.bookBox);
    if (!box.containsKey(updated.id)) return;
    await box.put(updated.id, updated);
    state = state.map((b) => b.id == updated.id ? updated : b).toList();
  }

  Future<void> toggleRead(String id) async {
    final box = await HiveHelper.openBox<Book>(HiveHelper.bookBox);
    final book = state.firstWhere((b) => b.id == id);
    final toggled = book.copyWith(isRead: !book.isRead);
    await box.put(toggled.id, toggled);
    state = state.map((b) => b.id == id ? toggled : b).toList();
  }

  Future<void> delete(String id) async {
    final box = await HiveHelper.openBox<Book>(HiveHelper.bookBox);
    await box.delete(id);
    state = state.where((b) => b.id != id).toList();
  }
}

final bookProvider = StateNotifierProvider<BookNotifier, List<Book>>((ref) {
  return BookNotifier();
});
