import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/utils/hive_helper.dart';
import '../../../features/diary/models/diary_entry.dart';
import '../../../features/diary/providers/diary_provider.dart';
import '../../../features/meal_plan/models/meal_plan.dart';
import '../../../features/meal_plan/providers/meal_plan_provider.dart';
import '../../../features/mood_tracker/models/mood_record.dart';
import '../../../features/mood_tracker/providers/mood_provider.dart';
import '../../../features/todo/models/task.dart';
import '../../../features/todo/providers/todo_provider.dart';
import '../models/weekly_progress_data.dart';

/// Computed provider tổng hợp dữ liệu tuần từ 4 feature provider.
/// Watch các provider khác để tự động cập nhật khi dữ liệu thay đổi.
final weeklyProgressProvider = Provider<WeeklyProgressData>((ref) {
  // Watch để trigger rebuild khi dữ liệu thay đổi
  ref.watch(todoProvider);
  ref.watch(moodProvider);
  ref.watch(mealPlanProvider);
  ref.watch(diaryProvider);

  return _computeWeeklyProgress();
});

/// Tính toán tất cả chỉ số tuần từ Hive boxes
WeeklyProgressData _computeWeeklyProgress() {
  final days = last7Days();

  final allTasks = _getAllTasks();
  final allMoodRecords = _getAllMoodRecords();
  final allMealPlans = _getAllMealPlans();
  final allDiaryEntries = _getAllDiaryEntries();

  final dailyCompletions = _buildDailyCompletions(allTasks, days);
  final streak = _calculateStreak(allTasks);
  final dominantMood = _findDominantMood(allMoodRecords, days);
  final mealCount = _countMeals(allMealPlans, days);
  final diaryCount = _countDiaries(allDiaryEntries, days);

  return WeeklyProgressData(
    dailyCompletions: dailyCompletions,
    streak: streak,
    dominantMood: dominantMood,
    mealCount: mealCount,
    diaryCount: diaryCount,
  );
}

/// Đọc tất cả tasks từ Hive box
List<Task> _getAllTasks() {
  if (!Hive.isBoxOpen(HiveHelper.taskBox)) return [];
  final box = Hive.box<Task>(HiveHelper.taskBox);
  return box.values.toList();
}

/// Đọc tất cả mood records từ Hive box
List<MoodRecord> _getAllMoodRecords() {
  if (!Hive.isBoxOpen(HiveHelper.moodBox)) return [];
  final box = Hive.box<MoodRecord>(HiveHelper.moodBox);
  return box.values.toList();
}

/// Đọc tất cả meal plans từ Hive box
List<MealPlan> _getAllMealPlans() {
  if (!Hive.isBoxOpen(HiveHelper.mealPlanBox)) return [];
  final box = Hive.box<MealPlan>(HiveHelper.mealPlanBox);
  return box.values.toList();
}

/// Đọc tất cả diary entries từ Hive box
List<DiaryEntry> _getAllDiaryEntries() {
  if (!Hive.isBoxOpen(HiveHelper.diaryBox)) return [];
  final box = Hive.box<DiaryEntry>(HiveHelper.diaryBox);
  return box.values.toList();
}

/// Tính dailyCompletions cho 7 ngày
List<DailyCompletion> _buildDailyCompletions(
  List<Task> allTasks,
  List<DateTime> days,
) {
  return days.map((date) {
    final dayTasks = allTasks.where((t) => isSameDay(t.date, date)).toList();
    final completed = dayTasks.where((t) => t.isCompleted).length;
    return DailyCompletion(
      date: date,
      completedCount: completed,
      totalCount: dayTasks.length,
    );
  }).toList();
}

/// Đếm ngày liên tiếp từ hôm nay trở về trước mà tất cả task hoàn thành.
/// Ngày không có task → bỏ qua, tiếp tục đếm.
/// Giới hạn tối đa 30 ngày để tránh vòng lặp vô hạn.
int _calculateStreak(List<Task> allTasks) {
  int streak = 0;
  final now = DateTime.now();
  DateTime current = DateTime(now.year, now.month, now.day);
  int daysChecked = 0;

  while (daysChecked < 30) {
    final dayTasks =
        allTasks.where((t) => isSameDay(t.date, current)).toList();

    if (dayTasks.isEmpty) {
      // Ngày không có task → bỏ qua, tiếp tục
      current = current.subtract(const Duration(days: 1));
      daysChecked++;
      continue;
    }

    final allCompleted = dayTasks.every((t) => t.isCompleted);
    if (allCompleted) {
      streak++;
      current = current.subtract(const Duration(days: 1));
      daysChecked++;
    } else {
      break;
    }
  }

  return streak;
}

/// Tìm mood phổ biến nhất trong 7 ngày.
/// Tie-break: chọn mood xuất hiện gần nhất (ngày mới nhất).
/// Trả về null nếu không có mood record nào.
String? _findDominantMood(List<MoodRecord> records, List<DateTime> days) {
  final weekRecords =
      records.where((r) => days.any((d) => isSameDay(r.date, d))).toList();

  if (weekRecords.isEmpty) return null;

  // Đếm tần suất mỗi emoji
  final frequency = <String, int>{};
  for (final record in weekRecords) {
    if (record.mood.isNotEmpty) {
      frequency[record.mood] = (frequency[record.mood] ?? 0) + 1;
    }
  }

  if (frequency.isEmpty) return null;

  // Tìm tần suất cao nhất
  final maxFreq = frequency.values.reduce((a, b) => a > b ? a : b);
  final topMoods = frequency.entries
      .where((e) => e.value == maxFreq)
      .map((e) => e.key)
      .toList();

  if (topMoods.length == 1) return topMoods.first;

  // Hòa → chọn mood xuất hiện gần nhất
  weekRecords.sort((a, b) => b.date.compareTo(a.date));
  return weekRecords.firstWhere((r) => topMoods.contains(r.mood)).mood;
}

/// Đếm bữa chính (breakfast, lunch, dinner) có nội dung non-empty trong 7 ngày
int _countMeals(List<MealPlan> mealPlans, List<DateTime> days) {
  int count = 0;
  for (final date in days) {
    final plan = mealPlans.cast<MealPlan?>().firstWhere(
          (p) => p != null && isSameDay(p.date, date),
          orElse: () => null,
        );
    if (plan != null) {
      if (plan.breakfast.trim().isNotEmpty) count++;
      if (plan.lunch.trim().isNotEmpty) count++;
      if (plan.dinner.trim().isNotEmpty) count++;
    }
  }
  return count;
}

/// Đếm diary entries có date trong 7 ngày
int _countDiaries(List<DiaryEntry> entries, List<DateTime> days) {
  return entries.where((e) => days.any((d) => isSameDay(e.date, d))).length;
}
