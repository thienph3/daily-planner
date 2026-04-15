import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../../../shared/providers/selected_date_provider.dart';
import '../models/schedule_item.dart';
import 'schedule_state.dart';

const _uuid = Uuid();

/// So sánh 2 DateTime chỉ theo ngày (bỏ qua giờ/phút/giây)
bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// StateNotifier quản lý logic nghiệp vụ Schedule.
/// Watch selectedDateProvider để tự động load items khi ngày thay đổi.
class ScheduleNotifier extends StateNotifier<ScheduleState> {
  final Ref _ref;

  ScheduleNotifier(this._ref) : super(const ScheduleState()) {
    _ref.listen<DateTime>(selectedDateProvider, (prev, next) {
      loadItems(next);
    });
    loadItems(_ref.read(selectedDateProvider));
  }

  /// Load schedule items từ Hive cho ngày đã chọn
  Future<void> loadItems(DateTime date) async {
    state = state.copyWith(isLoading: true);
    final box = await HiveHelper.openBox<ScheduleItem>(
      HiveHelper.scheduleBox,
    );
    final itemsForDate =
        box.values.where((item) => _isSameDay(item.date, date)).toList();

    state = state.copyWith(items: itemsForDate, isLoading: false);
  }

  /// Tạo schedule item mới với uuid, validate, lưu vào Hive
  Future<void> addItem({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    int color = 0xFFFFB6C1,
  }) async {
    if (title.trim().isEmpty) return;
    if (!endTime.isAfter(startTime)) return;

    final selectedDate = _ref.read(selectedDateProvider);
    final box = await HiveHelper.openBox<ScheduleItem>(
      HiveHelper.scheduleBox,
    );
    final newItem = ScheduleItem(
      id: _uuid.v4(),
      title: title.trim(),
      startTime: startTime,
      endTime: endTime,
      date: selectedDate,
      color: color,
    );

    await box.put(newItem.id, newItem);
    state = state.copyWith(items: [...state.items, newItem]);
  }

  /// Cập nhật schedule item, validate, lưu vào Hive
  Future<void> updateItem(ScheduleItem updatedItem) async {
    if (updatedItem.title.trim().isEmpty) return;
    if (!updatedItem.endTime.isAfter(updatedItem.startTime)) return;

    final box = await HiveHelper.openBox<ScheduleItem>(
      HiveHelper.scheduleBox,
    );
    if (!box.containsKey(updatedItem.id)) return;

    await box.put(updatedItem.id, updatedItem);
    final updatedItems = state.items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  /// Xóa schedule item khỏi Hive
  Future<void> deleteItem(String itemId) async {
    final box = await HiveHelper.openBox<ScheduleItem>(
      HiveHelper.scheduleBox,
    );
    if (!box.containsKey(itemId)) return;

    await box.delete(itemId);
    final updatedItems = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
  }
}

/// Riverpod provider cho ScheduleNotifier
final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, ScheduleState>((ref) {
  return ScheduleNotifier(ref);
});
