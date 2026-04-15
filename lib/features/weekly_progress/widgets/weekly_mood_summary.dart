import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

/// Mapping emoji → nhãn mô tả tiếng Việt
const Map<String, String> _moodLabels = {
  '😊': 'Vui vẻ',
  '😢': 'Buồn',
  '😡': 'Giận',
  '😴': 'Mệt',
  '🥰': 'Hạnh phúc',
};

/// Widget hiển thị mood phổ biến nhất trong tuần.
class WeeklyMoodSummary extends StatelessWidget {
  final String? dominantMood;

  const WeeklyMoodSummary({super.key, required this.dominantMood});

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
            Text(
              'Mood tuần này',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            if (dominantMood != null) ...[
              Text(dominantMood!, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 4),
              Text(
                _moodLabels[dominantMood] ?? dominantMood!,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ] else
              Text(
                'Chưa có mood nào 🌸',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
