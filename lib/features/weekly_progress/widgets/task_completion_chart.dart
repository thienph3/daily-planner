import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../models/weekly_progress_data.dart';

/// Bar chart hiển thị tỷ lệ hoàn thành task 7 ngày gần nhất.
class TaskCompletionChart extends StatelessWidget {
  final List<DailyCompletion> dailyCompletions;

  const TaskCompletionChart({super.key, required this.dailyCompletions});

  static const double _maxBarHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoàn thành task ✅',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.paddingStandard),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailyCompletions.map(_buildBar).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(DailyCompletion completion) {
    final percent = (completion.rate * 100).round();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$percent%',
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 28,
          height: _maxBarHeight * completion.rate,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.accent, AppColors.primary],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          weekdayLabel(completion.date),
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
