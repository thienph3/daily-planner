import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/mood_provider.dart';
import '../utils/mood_utils.dart';

/// Widget hiển thị biểu đồ mood 7 ngày gần nhất.
class MoodWeeklyChart extends ConsumerWidget {
  const MoodWeeklyChart({super.key});

  /// Màu bar theo mood level
  static const _barColors = {
    1: AppColors.error,
    2: AppColors.primary,
    3: AppColors.secondary,
    4: AppColors.accent,
    5: AppColors.success,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodProvider);
    final days = last7Days();
    final weekRecords = state.weekRecords;

    return Card(
      elevation: 2,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tuần này 📊',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.gapItem),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: days.map((day) {
                  // Tìm record cho ngày này
                  final record = weekRecords
                      .where((r) => isSameDay(r.date, day))
                      .firstOrNull;
                  final level = record != null
                      ? (moodLevels[record.mood] ?? 3)
                      : 0;
                  final emoji = record?.mood;
                  final label = DateFormat('dd/MM').format(day);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            emoji ?? '—',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: level > 0 ? (level / 5) * 100 : 4,
                            decoration: BoxDecoration(
                              color: level > 0
                                  ? _barColors[level] ??
                                      AppColors.accent
                                  : AppColors.textSecondary
                                      .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
