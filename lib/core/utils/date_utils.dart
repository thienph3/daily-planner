// Shared date utility functions cho toàn bộ ứng dụng.

/// So sánh 2 DateTime chỉ theo ngày (bỏ qua giờ/phút/giây)
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Trả về 7 ngày gần nhất (bao gồm hôm nay), sắp xếp từ cũ đến mới
List<DateTime> last7Days() {
  final today = DateTime.now();
  return List.generate(7, (i) {
    final d = today.subtract(Duration(days: 6 - i));
    return DateTime(d.year, d.month, d.day);
  });
}

/// Lấy nhãn thứ viết tắt tiếng Việt cho DateTime
String weekdayLabel(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return 'T2';
    case DateTime.tuesday:
      return 'T3';
    case DateTime.wednesday:
      return 'T4';
    case DateTime.thursday:
      return 'T5';
    case DateTime.friday:
      return 'T6';
    case DateTime.saturday:
      return 'T7';
    case DateTime.sunday:
      return 'CN';
    default:
      return '';
  }
}
