import 'package:hive/hive.dart';

part 'book_category.g.dart';

@HiveType(typeId: 6)
class BookCategory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String emoji;

  BookCategory({
    required this.id,
    required this.name,
    this.emoji = '📚',
  });

  BookCategory copyWith({String? id, String? name, String? emoji}) {
    return BookCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
    );
  }
}
