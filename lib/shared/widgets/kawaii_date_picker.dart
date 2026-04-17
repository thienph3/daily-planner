import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../providers/selected_date_provider.dart';
import 'quick_date_bar.dart';

/// Widget chọn ngày dùng chung kết hợp header ngày + calendar icon + QuickDateBar.
/// Tự watch selectedDateProvider, không cần truyền callback từ bên ngoài.
class KawaiiDatePicker extends ConsumerWidget {
  const KawaiiDatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final dateStr = _formatDate(selectedDate);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingStandard,
        vertical: AppSpacing.gapItem,
      ),
      padding: const EdgeInsets.all(AppSpacing.paddingStandard),
      decoration: BoxDecoration(
        color: AppColors.surfaceFor(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryFor(context),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _openCalendarPicker(context, ref),
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const QuickDateBar(),
        ],
      ),
    );
  }

  /// Format ngày dạng "Thứ X, dd/MM/yyyy" tiếng Việt.
  String _formatDate(DateTime date) {
    final weekday = _weekdayVietnamese(date.weekday);
    final formatted = DateFormat('dd/MM/yyyy').format(date);
    return '$weekday, $formatted';
  }

  String _weekdayVietnamese(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Thứ 2';
      case DateTime.tuesday:
        return 'Thứ 3';
      case DateTime.wednesday:
        return 'Thứ 4';
      case DateTime.thursday:
        return 'Thứ 5';
      case DateTime.friday:
        return 'Thứ 6';
      case DateTime.saturday:
        return 'Thứ 7';
      case DateTime.sunday:
        return 'Chủ nhật';
      default:
        return '';
    }
  }

  Future<void> _openCalendarPicker(BuildContext context, WidgetRef ref) async {
    final currentDate = ref.read(selectedDateProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state =
          DateTime(picked.year, picked.month, picked.day);
    }
  }
}
