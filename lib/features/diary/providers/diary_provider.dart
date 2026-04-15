import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../models/diary_entry.dart';
import 'diary_state.dart';

const _uuid = Uuid();

/// StateNotifier quản lý CRUD operations cho diary entries
class DiaryNotifier extends StateNotifier<DiaryState> {
  DiaryNotifier() : super(const DiaryState());

  /// Load tất cả diary entries từ Hive
  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true);
    final box = await HiveHelper.openBox<DiaryEntry>(HiveHelper.diaryBox);
    final entries = box.values.toList();
    state = state.copyWith(entries: entries, isLoading: false);
  }

  /// Tạo entry mới với uuid, lưu vào Hive
  Future<void> addEntry({
    required String content,
    required String mood,
  }) async {
    final box = await HiveHelper.openBox<DiaryEntry>(HiveHelper.diaryBox);
    final entry = DiaryEntry(
      id: _uuid.v4(),
      date: DateTime.now(),
      content: content,
      mood: mood,
    );
    await box.put(entry.id, entry);
    state = state.copyWith(entries: [...state.entries, entry]);
  }

  /// Cập nhật entry trong Hive
  Future<void> updateEntry(DiaryEntry updatedEntry) async {
    final box = await HiveHelper.openBox<DiaryEntry>(HiveHelper.diaryBox);
    if (!box.containsKey(updatedEntry.id)) return;
    await box.put(updatedEntry.id, updatedEntry);
    final updatedEntries = state.entries.map((e) {
      return e.id == updatedEntry.id ? updatedEntry : e;
    }).toList();
    state = state.copyWith(entries: updatedEntries);
  }

  /// Xóa entry khỏi Hive
  Future<void> deleteEntry(String entryId) async {
    final box = await HiveHelper.openBox<DiaryEntry>(HiveHelper.diaryBox);
    await box.delete(entryId);
    final updatedEntries =
        state.entries.where((e) => e.id != entryId).toList();
    state = state.copyWith(entries: updatedEntries);
  }
}

/// Provider cho DiaryNotifier
final diaryProvider = StateNotifierProvider<DiaryNotifier, DiaryState>((ref) {
  return DiaryNotifier();
});
