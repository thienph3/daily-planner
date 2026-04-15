import 'package:hive/hive.dart';

part 'diary_entry.g.dart';

@HiveType(typeId: 3)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String mood;

  DiaryEntry({
    required this.id,
    required this.date,
    this.content = '',
    this.mood = '',
  });

  /// Tạo bản sao với các trường được cập nhật
  DiaryEntry copyWith({
    String? id,
    DateTime? date,
    String? content,
    String? mood,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      mood: mood ?? this.mood,
    );
  }
}
