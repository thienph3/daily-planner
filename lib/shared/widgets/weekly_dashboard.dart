import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../features/weekly_progress/providers/weekly_progress_provider.dart';
import '../../features/weekly_progress/widgets/streak_counter.dart';
import '../../features/weekly_progress/widgets/task_completion_chart.dart';
import '../../features/weekly_progress/widgets/weekly_mood_summary.dart';
import '../../features/weekly_progress/widgets/weekly_stats_card.dart';

/// Dashboard tổng quan tiến độ tuần — tổng hợp task, streak, mood, stats.
class WeeklyDashboard extends ConsumerWidget {
  const WeeklyDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(weeklyProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundFor(context),
      appBar: AppBar(
        title: Text(
          'Tiến độ tuần này 📊',
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryFor(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          children: [
            TaskCompletionChart(dailyCompletions: data.dailyCompletions),
            const SizedBox(height: AppSpacing.paddingStandard),
            StreakCounter(streak: data.streak),
            const SizedBox(height: AppSpacing.paddingStandard),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WeeklyMoodSummary(dominantMood: data.dominantMood),
                ),
                const SizedBox(width: AppSpacing.gapItem),
                Expanded(
                  child: WeeklyStatsCard(
                    mealCount: data.mealCount,
                    maxMeals: data.maxMeals,
                    diaryCount: data.diaryCount,
                    maxDiaries: data.maxDiaries,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
