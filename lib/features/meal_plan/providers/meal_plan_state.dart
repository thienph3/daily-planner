import '../models/meal_plan.dart';

/// Immutable state class chứa trạng thái của feature kế hoạch bữa ăn.
class MealPlanState {
  final MealPlan? mealPlan;

  const MealPlanState({
    this.mealPlan,
  });

  /// Tạo bản sao state với các trường được cập nhật.
  MealPlanState copyWith({
    MealPlan? mealPlan,
  }) {
    return MealPlanState(
      mealPlan: mealPlan ?? this.mealPlan,
    );
  }
}
