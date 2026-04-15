import 'package:hive/hive.dart';

part 'schedule_item.g.dart';

@HiveType(typeId: 1)
class ScheduleItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime endTime;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final int color;

  ScheduleItem({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.date,
    this.color = 0xFFFFB6C1,
  });

  /// Tạo bản sao với các trường được cập nhật
  ScheduleItem copyWith({
    String? id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? date,
    int? color,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      color: color ?? this.color,
    );
  }
}
