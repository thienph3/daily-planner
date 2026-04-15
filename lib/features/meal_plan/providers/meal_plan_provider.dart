import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../../../shared/providers/selected_date_provider.dart';
import '../models/meal_plan.dart';
import 'meal_plan_state.dart';

/// StateNotifier quản lý logic nghiệp vụ kế hoạch bữa ăn.
/// Watch selectedDateProvider để tự động load meal plan khi ngày thay đổi.
class MealPlanNotifier extends StateNotifier<MealPlanState> {
  final Ref _ref;

  MealPlanNotifier(this._ref) : super(const MealPlanState()) {
    _ref.listen<DateTime>(selectedDateProvider, (prev, next) {
      loadMealPlan(next);
    });
    loadMealPlan(_ref.read(selectedDateProvider));
  }

  static const _uuid = Uuid();

  /// So sánh 2 ngày chỉ theo year, month, day.
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Load MealPlan từ Hive cho ngày đã chọn.
  /// Nếu không tìm thấy, tạo MealPlan mới với các trường rỗng.
  Future<void> loadMealPlan(DateTime date) async {
    final box = await HiveHelper.openBox<MealPlan>(HiveHelper.mealPlanBox);

    MealPlan? found;
    for (final item in box.values) {
      if (_isSameDay(item.date, date)) {
        found = item;
        break;
      }
    }

    if (found != null) {
      state = state.copyWith(mealPlan: found);
    } else {
      final newPlan = MealPlan(
        id: _uuid.v4(),
        date: date,
      );
      await box.put(newPlan.id, newPlan);
      state = state.copyWith(mealPlan: newPlan);
    }
  }

  /// Cập nhật bữa sáng.
  Future<void> updateBreakfast(String content) async {
    if (state.mealPlan == null) return;
    final updated = state.mealPlan!.copyWith(breakfast: content);
    state = state.copyWith(mealPlan: updated);
    await _saveMealPlan();
  }

  /// Cập nhật bữa trưa.
  Future<void> updateLunch(String content) async {
    if (state.mealPlan == null) return;
    final updated = state.mealPlan!.copyWith(lunch: content);
    state = state.copyWith(mealPlan: updated);
    await _saveMealPlan();
  }

  /// Cập nhật bữa tối.
  Future<void> updateDinner(String content) async {
    if (state.mealPlan == null) return;
    final updated = state.mealPlan!.copyWith(dinner: content);
    state = state.copyWith(mealPlan: updated);
    await _saveMealPlan();
  }

  /// Thêm snack mới vào danh sách.
  Future<void> addSnack(String content) async {
    if (state.mealPlan == null) return;
    if (content.trim().isEmpty) return;
    final snacks = List<String>.from(state.mealPlan!.snacks)..add(content);
    final updated = state.mealPlan!.copyWith(snacks: snacks);
    state = state.copyWith(mealPlan: updated);
    await _saveMealPlan();
  }

  /// Cập nhật snack tại vị trí index.
  Future<void> updateSnack(int index, String content) async {
    if (state.mealPlan == null) return;
    if (content.trim().isEmpty) return;
    final snacks = List<String>.from(state.mealPlan!.snacks);
    if (index < 0 || index >= snacks.length) return;
    snacks[index] = content;
    final updated = state.mealPlan!.copyWith(snacks: snacks);
    state = state.copyWith(mealPlan: updated);
    await _saveMealPlan();
  }

  /// Xóa snack tại vị trí index.
  Future<void> removeSnack(int index) async {
    if (state.mealPlan == null) return;
    final snacks = List<String>.from(state.mealPlan!.snacks);
    if (index < 0 || index >= snacks.length) return;
    snacks.removeAt(index);
    final updated = state.mealPlan!.copyWith(snacks: snacks);
    state = state.copyWith(mealPlan: updated);
    await _saveMealPlan();
  }

  /// Lưu MealPlan hiện tại vào Hive box.
  Future<void> _saveMealPlan() async {
    if (state.mealPlan == null) return;
    final box = await HiveHelper.openBox<MealPlan>(HiveHelper.mealPlanBox);
    await box.put(state.mealPlan!.id, state.mealPlan!);
  }
}

/// Provider cho MealPlanNotifier.
final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, MealPlanState>((ref) {
  return MealPlanNotifier(ref);
});
