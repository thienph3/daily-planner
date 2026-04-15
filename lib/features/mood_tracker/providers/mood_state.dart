import '../models/mood_record.dart';
import '../utils/mood_utils.dart';

/// Immutable state class cho Mood Tracker feature.
class MoodState {
  final List<MoodRecord> records;
  final DateTime selectedMonth;

  MoodState({
    this.records = const [],
    DateTime? selectedMonth,
  }) : selectedMonth = selectedMonth ?? DateTime.now();

  MoodState copyWith({
    List<MoodRecord>? records,
    DateTime? selectedMonth,
  }) {
    return MoodState(
      records: records ?? this.records,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }

  /// Lấy MoodRecord của ngày hôm nay (null nếu chưa có)
  MoodRecord? get todayRecord {
    final now = DateTime.now();
    for (final record in records) {
      if (isSameDay(record.date, now)) return record;
    }
    return null;
  }

  /// Lấy danh sách records của tháng đang chọn
  List<MoodRecord> get monthRecords {
    return records
        .where((r) =>
            r.date.year == selectedMonth.year &&
            r.date.month == selectedMonth.month)
        .toList();
  }

  /// Lấy danh sách records 7 ngày gần nhất
  List<MoodRecord> get weekRecords {
    final days = last7Days();
    return records
        .where((r) => days.any((d) => isSameDay(r.date, d)))
        .toList();
  }

  /// Map {day: MoodRecord} cho tháng đang chọn (key = ngày trong tháng)
  Map<int, MoodRecord> get monthMoodMap {
    final map = <int, MoodRecord>{};
    for (final record in monthRecords) {
      map[record.date.day] = record;
    }
    return map;
  }
}
