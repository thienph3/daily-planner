import 'package:hive/hive.dart';

part 'class_note.g.dart';

@HiveType(typeId: 12)
enum NoteTag {
  @HiveField(0)
  lesson, // Bài giảng

  @HiveField(1)
  student, // Học sinh

  @HiveField(2)
  reminder, // Nhắc nhở

  @HiveField(3)
  other, // Khác
}

@HiveType(typeId: 11)
class ClassNote extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String classId;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final NoteTag tag;

  ClassNote({
    required this.id,
    required this.classId,
    this.content = '',
    required this.date,
    this.tag = NoteTag.other,
  });

  ClassNote copyWith({
    String? id,
    String? classId,
    String? content,
    DateTime? date,
    NoteTag? tag,
  }) {
    return ClassNote(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      content: content ?? this.content,
      date: date ?? this.date,
      tag: tag ?? this.tag,
    );
  }
}
