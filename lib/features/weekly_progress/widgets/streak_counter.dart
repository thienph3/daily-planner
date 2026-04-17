import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

/// Widget hiển thị streak — số ngày liên tiếp hoàn thành tất cả task.
class StreakCounter extends StatelessWidget {
  final int streak;

  const StreakCounter({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          gradient: streak > 0
              ? const LinearGradient(
                  colors: [Color(0xFFFFF5F5), Color(0xFFFFE8D6)],
                )
              : null,
        ),
        child: streak > 0 ? _buildActiveStreak(context) : _buildEmptyStreak(context),
      ),
    );
  }

  Widget _buildActiveStreak(BuildContext context) {
    return Row(
      children: [
        const Text('🔥', style: TextStyle(fontSize: 32)),
        const SizedBox(width: AppSpacing.gapItem),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Streak',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: AppColors.textSecondaryFor(context),
              ),
            ),
            Text(
              '$streak ngày',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryFor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyStreak(BuildContext context) {
    return Row(
      children: [
        const Text('⭐', style: TextStyle(fontSize: 32)),
        const SizedBox(width: AppSpacing.gapItem),
        Expanded(
          child: Text(
            'Bắt đầu streak mới nào! 💪',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryFor(context),
            ),
          ),
        ),
      ],
    );
  }
}
