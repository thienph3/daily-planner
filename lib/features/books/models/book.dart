import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 7)
class Book extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final bool isRead;

  Book({
    required this.id,
    required this.title,
    this.categoryId = '',
    this.isRead = false,
  });

  Book copyWith({String? id, String? title, String? categoryId, bool? isRead}) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      isRead: isRead ?? this.isRead,
    );
  }
}
