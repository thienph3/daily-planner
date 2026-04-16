import 'package:hive/hive.dart';

part 'class_room.g.dart';

@HiveType(typeId: 10)
class ClassRoom extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String emoji;

  @HiveField(3)
  final int color;

  ClassRoom({
    required this.id,
    required this.name,
    this.emoji = '🏫',
    this.color = 0xFFFFB6C1,
  });

  ClassRoom copyWith({String? id, String? name, String? emoji, int? color}) {
    return ClassRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
    );
  }
}
