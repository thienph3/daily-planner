import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

/// Widget hiển thị thống kê bữa ăn và nhật ký trong tuần.
class WeeklyStatsCard extends StatelessWidget {
  final int mealCount;
  final int maxMeals;
  final int diaryCount;
  final int maxDiaries;

  const WeeklyStatsCard({
    super.key,
    required this.mealCount,
    required this.maxMeals,
    required this.diaryCount,
    required this.maxDiaries,
  });

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
          children: [
            _buildStatRow(
              context: context,
              emoji: '🍽️',
              label: 'Bữa ăn',
              count: mealCount,
              max: maxMeals,
              color: AppColors.secondary,
            ),
            const SizedBox(height: AppSpacing.gapItem),
            _buildStatRow(
              context: context,
              emoji: '📝',
              label: 'Nhật ký',
              count: diaryCount,
              max: maxDiaries,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required BuildContext context,
    required String emoji,
    required String label,
    required int count,
    required int max,
    required Color color,
  }) {
    final progress = max == 0 ? 0.0 : count / max;
    return Column(
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryFor(context),
              ),
            ),
            const Spacer(),
            Text(
              '$count/$max',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryFor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 8,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
