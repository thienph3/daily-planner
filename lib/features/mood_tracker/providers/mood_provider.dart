import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../models/mood_record.dart';
import '../utils/mood_utils.dart';
import 'mood_state.dart';

/// StateNotifier quản lý logic nghiệp vụ và CRUD cho Mood Tracker.
class MoodNotifier extends StateNotifier<MoodState> {
  MoodNotifier() : super(MoodState());

  static const _uuid = Uuid();

  /// Load tất cả mood records từ Hive box
  Future<void> loadRecords() async {
    final box = await HiveHelper.openBox<MoodRecord>(HiveHelper.moodBox);
    final records = box.values.toList();
    state = state.copyWith(records: records);
  }

  /// Lưu mood cho ngày hôm nay.
  /// Nếu đã có record cho hôm nay → cập nhật.
  /// Nếu chưa có → tạo mới với uuid.
  Future<void> saveTodayMood({
    required String mood,
    String note = '',
  }) async {
    final box = await HiveHelper.openBox<MoodRecord>(HiveHelper.moodBox);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Tìm record hôm nay
    final existingIndex =
        state.records.indexWhere((r) => isSameDay(r.date, today));

    if (existingIndex >= 0) {
      // Cập nhật record hiện tại
      final existing = state.records[existingIndex];
      final updated = existing.copyWith(mood: mood, note: note);

      // Tìm key trong Hive box
      final boxKey = box.keys.firstWhere(
        (k) => box.get(k)?.id == existing.id,
        orElse: () => null,
      );
      if (boxKey != null) {
        await box.put(boxKey, updated);
      }

      final updatedRecords = List<MoodRecord>.from(state.records);
      updatedRecords[existingIndex] = updated;
      state = state.copyWith(records: updatedRecords);
    } else {
      // Tạo record mới
      final record = MoodRecord(
        id: _uuid.v4(),
        date: today,
        mood: mood,
        note: note,
      );
      await box.add(record);

      state = state.copyWith(records: [...state.records, record]);
    }
  }

  /// Chuyển tháng hiển thị trên calendar
  void changeMonth(DateTime month) {
    state = state.copyWith(selectedMonth: DateTime(month.year, month.month));
  }

  /// Lấy record theo ngày cụ thể
  MoodRecord? getRecordByDate(DateTime date) {
    for (final record in state.records) {
      if (isSameDay(record.date, date)) return record;
    }
    return null;
  }
}

/// Riverpod provider cho MoodNotifier
final moodProvider = StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  return MoodNotifier();
});
