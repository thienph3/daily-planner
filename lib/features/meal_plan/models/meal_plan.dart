import 'package:hive/hive.dart';

part 'meal_plan.g.dart';

@HiveType(typeId: 2)
class MealPlan extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String breakfast;

  @HiveField(3)
  final String lunch;

  @HiveField(4)
  final String dinner;

  @HiveField(5)
  final List<String> snacks;

  MealPlan({
    required this.id,
    required this.date,
    this.breakfast = '',
    this.lunch = '',
    this.dinner = '',
    this.snacks = const [],
  });

  /// Tạo bản sao MealPlan với các trường được cập nhật.
  MealPlan copyWith({
    String? id,
    DateTime? date,
    String? breakfast,
    String? lunch,
    String? dinner,
    List<String>? snacks,
  }) {
    return MealPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      snacks: snacks ?? List<String>.from(this.snacks),
    );
  }
}
