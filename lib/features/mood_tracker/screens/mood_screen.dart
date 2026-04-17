import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_calendar.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mood_weekly_chart.dart';

/// Màn hình chính của Mood Tracker.
class MoodScreen extends ConsumerStatefulWidget {
  const MoodScreen({super.key});

  @override
  ConsumerState<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends ConsumerState<MoodScreen> {
  @override
  void initState() {
    super.initState();
    // Load tất cả mood records khi mở màn hình
    Future.microtask(() => ref.read(moodProvider.notifier).loadRecords());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mood Tracker 🌈',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimaryFor(context),
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundFor(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundFor(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          children: [
            _buildTodaySection(context),
            const SizedBox(height: AppSpacing.sectionSpacing),
            const MoodSelector(),
            const SizedBox(height: AppSpacing.sectionSpacing),
            const MoodWeeklyChart(),
            const SizedBox(height: AppSpacing.sectionSpacing),
            const MoodCalendar(),
            const SizedBox(height: AppSpacing.sectionSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySection(BuildContext context) {
    final todayRecord = ref.watch(moodProvider).todayRecord;

    return Card(
      elevation: 2,
      color: AppColors.surfaceFor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: todayRecord != null
            ? Row(
                children: [
                  Text(todayRecord.mood, style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: AppSpacing.gapItem),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mood hôm nay',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimaryFor(context),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (todayRecord.note.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            todayRecord.note,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondaryFor(context),
                                    ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.gapItem),
                  child: Text(
                    'Hôm nay bạn cảm thấy thế nào? 🌸',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondaryFor(context),
                        ),
                  ),
                ),
              ),
      ),
    );
  }
}
