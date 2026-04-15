import 'package:hive/hive.dart';

part 'mood_record.g.dart';

@HiveType(typeId: 4)
class MoodRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String mood;

  @HiveField(3)
  final String note;

  MoodRecord({
    required this.id,
    required this.date,
    this.mood = '',
    this.note = '',
  });

  MoodRecord copyWith({
    String? id,
    DateTime? date,
    String? mood,
    String? note,
  }) {
    return MoodRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      note: note ?? this.note,
    );
  }
}
