/// Dữ liệu hoàn thành task cho 1 ngày
class DailyCompletion {
  final DateTime date;
  final int completedCount;
  final int totalCount;

  const DailyCompletion({
    required this.date,
    required this.completedCount,
    required this.totalCount,
  });

  /// Tỷ lệ hoàn thành (0.0 - 1.0), trả về 0.0 nếu totalCount = 0
  double get rate => totalCount == 0 ? 0.0 : completedCount / totalCount;
}

/// Dữ liệu tổng hợp tuần
class WeeklyProgressData {
  final List<DailyCompletion> dailyCompletions; // luôn 7 phần tử, cũ → mới
  final int streak;
  final String? dominantMood; // emoji mood phổ biến nhất, null nếu không có data
  final int mealCount; // số bữa ăn chính đã lên kế hoạch
  final int maxMeals; // 21 (7 ngày x 3 bữa)
  final int diaryCount; // số nhật ký đã viết
  final int maxDiaries; // 7

  const WeeklyProgressData({
    required this.dailyCompletions,
    required this.streak,
    this.dominantMood,
    required this.mealCount,
    this.maxMeals = 21,
    required this.diaryCount,
    this.maxDiaries = 7,
  });
}
