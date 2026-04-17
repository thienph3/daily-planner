import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/mood_provider.dart';
import '../utils/mood_utils.dart';

/// Widget hiển thị lịch tháng với emoji mood cho mỗi ngày.
class MoodCalendar extends ConsumerWidget {
  const MoodCalendar({super.key});

  static const _dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodProvider);
    final moodMap = state.monthMoodMap;
    final month = state.selectedMonth;
    final first = firstDayOfMonth(month);
    final last = lastDayOfMonth(month);
    final now = DateTime.now();

    // Ngày bắt đầu tuần (thứ 2 = 1)
    final startWeekday = first.weekday; // 1=Mon ... 7=Sun
    final daysInMonth = last.day;
    final totalCells = startWeekday - 1 + daysInMonth;

    return Card(
      elevation: 2,
      color: AppColors.surfaceFor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          children: [
            _buildHeader(context, ref, month),
            const SizedBox(height: AppSpacing.gapItem),
            _buildDayLabels(context),
            const SizedBox(height: 8),
            _buildGrid(context, startWeekday, daysInMonth, totalCells,
                moodMap, month, now),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, DateTime month) {
    final label = DateFormat('MMMM yyyy', 'vi').format(month);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left, color: AppColors.textPrimaryFor(context)),
          onPressed: () {
            ref.read(moodProvider.notifier).changeMonth(
                  DateTime(month.year, month.month - 1),
                );
          },
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimaryFor(context),
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right, color: AppColors.textPrimaryFor(context)),
          onPressed: () {
            ref.read(moodProvider.notifier).changeMonth(
                  DateTime(month.year, month.month + 1),
                );
          },
        ),
      ],
    );
  }

  Widget _buildDayLabels(BuildContext context) {
    return Row(
      children: _dayLabels
          .map((label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryFor(context),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    int startWeekday,
    int daysInMonth,
    int totalCells,
    Map<int, dynamic> moodMap,
    DateTime month,
    DateTime now,
  ) {
    // Tính số hàng cần thiết
    final rows = ((totalCells) / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final index = row * 7 + col;
            final day = index - (startWeekday - 1) + 1;

            if (day < 1 || day > daysInMonth) {
              return const Expanded(child: SizedBox(height: 40));
            }

            final isToday = isSameDay(
              DateTime(month.year, month.month, day),
              now,
            );
            final record = moodMap[day];

            return Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
                  border: isToday
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: record != null
                      ? Text(record.mood, style: const TextStyle(fontSize: 18))
                      : Text(
                          '$day',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondaryFor(context),
                                  ),
                        ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
