import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 5)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String emoji;

  Category({
    required this.id,
    required this.name,
    this.emoji = '📁',
  });

  Category copyWith({String? id, String? name, String? emoji}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
    );
  }
}
