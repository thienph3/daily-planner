// Helper functions và constants cho Mood Tracker feature.

/// Danh sách 5 emoji mood
const List<String> moodEmojis = ['😊', '😢', '😡', '😴', '🥰'];

/// Mapping emoji → giá trị số để vẽ biểu đồ
const Map<String, int> moodLevels = {
  '😡': 1,
  '😢': 2,
  '😴': 3,
  '😊': 4,
  '🥰': 5,
};

/// So sánh 2 DateTime chỉ theo ngày (bỏ qua giờ/phút/giây)
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Ngày đầu tiên của tháng
DateTime firstDayOfMonth(DateTime month) {
  return DateTime(month.year, month.month, 1);
}

/// Ngày cuối cùng của tháng
DateTime lastDayOfMonth(DateTime month) {
  return DateTime(month.year, month.month + 1, 0);
}

/// Trả về 7 ngày gần nhất (bao gồm hôm nay), sắp xếp từ cũ đến mới
List<DateTime> last7Days() {
  final today = DateTime.now();
  return List.generate(7, (i) {
    final d = today.subtract(Duration(days: 6 - i));
    return DateTime(d.year, d.month, d.day);
  });
}
