import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../providers/selected_date_provider.dart';

/// Thanh chọn ngày nhanh hiển thị 7 ngày centered quanh ngày đang chọn.
class QuickDateBar extends ConsumerWidget {
  const QuickDateBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    // Tính 7 ngày: selectedDate - 3 → selectedDate + 3
    final days = List.generate(7, (i) {
      return selectedDate.add(Duration(days: i - 3));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((date) {
        final isSelected = _isSameDay(date, selectedDate);
        final isToday = _isSameDay(date, normalizedToday);

        return _DateChip(
          date: date,
          isSelected: isSelected,
          isToday: isToday,
          onTap: () {
            ref.read(selectedDateProvider.notifier).state =
                DateTime(date.year, date.month, date.day);
          },
        );
      }).toList(),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Chip hiển thị 1 ngày trong QuickDateBar.
class _DateChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DateChip({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _weekdayLabel(date.weekday),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            // Chấm tròn đánh dấu ngày hôm nay
            if (isToday && !isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ] else
              const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'T2';
      case DateTime.tuesday:
        return 'T3';
      case DateTime.wednesday:
        return 'T4';
      case DateTime.thursday:
        return 'T5';
      case DateTime.friday:
        return 'T6';
      case DateTime.saturday:
        return 'T7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }
}
