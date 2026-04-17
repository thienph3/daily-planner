import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/kawaii_date_picker.dart';
import '../models/meal_type.dart';
import '../providers/meal_plan_provider.dart';
import '../widgets/edit_meal_dialog.dart';
import '../widgets/meal_card.dart';

/// Màn hình chính hiển thị kế hoạch bữa ăn cho ngày được chọn.
class MealPlanScreen extends ConsumerWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mealPlanProvider);
    final plan = state.mealPlan;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🍱 Kế hoạch bữa ăn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const KawaiiDatePicker(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingStandard,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MealCard(
                    emoji: MealType.breakfast.emoji,
                    title: MealType.breakfast.label,
                    content: plan?.breakfast ?? '',
                    onTap: () => _editMeal(context, ref, MealType.breakfast),
                  ),
                  const SizedBox(height: AppSpacing.gapItem),
                  MealCard(
                    emoji: MealType.lunch.emoji,
                    title: MealType.lunch.label,
                    content: plan?.lunch ?? '',
                    onTap: () => _editMeal(context, ref, MealType.lunch),
                  ),
                  const SizedBox(height: AppSpacing.gapItem),
                  MealCard(
                    emoji: MealType.dinner.emoji,
                    title: MealType.dinner.label,
                    content: plan?.dinner ?? '',
                    onTap: () => _editMeal(context, ref, MealType.dinner),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Snack ${MealType.snack.emoji}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _addSnack(context, ref),
                        icon: const Icon(Icons.add_circle_rounded),
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (plan == null || plan.snacks.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.paddingStandard,
                        ),
                        child: Text(
                          'Thêm snack cho ngày hôm nay 🍪',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(plan.snacks.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MealCard(
                          emoji: MealType.snack.emoji,
                          title: plan.snacks[index],
                          content: '',
                          onTap: () =>
                              _editSnack(context, ref, index, plan.snacks[index]),
                          onDelete: () => ref
                              .read(mealPlanProvider.notifier)
                              .removeSnack(index),
                        ),
                      );
                    }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editMeal(
      BuildContext context, WidgetRef ref, MealType type) async {
    final plan = ref.read(mealPlanProvider).mealPlan;
    if (plan == null) return;

    String currentContent;
    switch (type) {
      case MealType.breakfast:
        currentContent = plan.breakfast;
      case MealType.lunch:
        currentContent = plan.lunch;
      case MealType.dinner:
        currentContent = plan.dinner;
      case MealType.snack:
        return;
    }

    final result = await EditMealDialog.show(
      context,
      title: type.label,
      emoji: type.emoji,
      initialContent: currentContent,
    );

    if (result == null) return;

    final notifier = ref.read(mealPlanProvider.notifier);
    switch (type) {
      case MealType.breakfast:
        await notifier.updateBreakfast(result);
      case MealType.lunch:
        await notifier.updateLunch(result);
      case MealType.dinner:
        await notifier.updateDinner(result);
      case MealType.snack:
        break;
    }
  }

  Future<void> _addSnack(BuildContext context, WidgetRef ref) async {
    final result = await EditMealDialog.show(
      context,
      title: MealType.snack.label,
      emoji: MealType.snack.emoji,
      requireNonEmpty: true,
    );
    if (result != null) {
      await ref.read(mealPlanProvider.notifier).addSnack(result);
    }
  }

  Future<void> _editSnack(
      BuildContext context, WidgetRef ref, int index, String current) async {
    final result = await EditMealDialog.show(
      context,
      title: MealType.snack.label,
      emoji: MealType.snack.emoji,
      initialContent: current,
      requireNonEmpty: true,
    );
    if (result != null) {
      await ref.read(mealPlanProvider.notifier).updateSnack(index, result);
    }
  }
}
