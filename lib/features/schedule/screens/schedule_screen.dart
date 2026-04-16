import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/providers/selected_date_provider.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/kawaii_date_picker.dart';
import '../../../shared/widgets/shimmer_widget.dart';
import '../models/schedule_item.dart';
import '../providers/schedule_provider.dart';
import '../widgets/add_schedule_dialog.dart';
import '../widgets/time_slot_card.dart';

/// Màn hình chính hiển thị timeline dọc theo giờ
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  static const int _startHour = 0;
  static const int _endHour = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scheduleProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final sortedItems = state.sortedItems;
    final now = DateTime.now();
    final isToday = _isSameDay(selectedDate, now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Thời gian biểu'),
      ),
      body: Column(
        children: [
          const KawaiiDatePicker(),
          Expanded(
            child: state.isLoading
                ? const ShimmerListWidget()
                : sortedItems.isEmpty
                    ? _buildEmptyState(context)
                    : _buildTimeline(context, ref, sortedItems, now, isToday),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSchedule(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _addSchedule(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddScheduleDialog(),
    );
    if (result != null) {
      await ref.read(scheduleProvider.notifier).addItem(
        title: result['title'] as String,
        startTime: result['startTime'] as DateTime,
        endTime: result['endTime'] as DateTime,
        color: result['color'] as int,
      );
    }
  }

  Future<void> _editSchedule(
      BuildContext context, WidgetRef ref, ScheduleItem item) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddScheduleDialog(existingItem: item),
    );
    if (result != null) {
      final updated = item.copyWith(
        title: result['title'] as String,
        startTime: result['startTime'] as DateTime,
        endTime: result['endTime'] as DateTime,
        color: result['color'] as int,
      );
      await ref.read(scheduleProvider.notifier).updateItem(updated);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.schedule,
      title: 'Lịch trình trống',
      subtitle: 'Hãy lên kế hoạch cho ngày hôm nay 📅',
    );
  }

  Widget _buildTimeline(
    BuildContext context,
    WidgetRef ref,
    List<ScheduleItem> sortedItems,
    DateTime now,
    bool isToday,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSpacing.gapItem,
        bottom: 80,
      ),
      itemCount: _endHour - _startHour + 1,
      itemBuilder: (context, index) {
        final hour = _startHour + index;
        final isCurrentHour = isToday && now.hour == hour;

        final itemsInSlot = sortedItems
            .where((item) => item.startTime.hour == hour)
            .toList();

        return _buildTimeSlotRow(context, ref, hour, isCurrentHour, itemsInSlot);
      },
    );
  }

  Widget _buildTimeSlotRow(
    BuildContext context,
    WidgetRef ref,
    int hour,
    bool isCurrentHour,
    List<ScheduleItem> items,
  ) {
    return Container(
      decoration: isCurrentHour
          ? BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
            )
          : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingStandard,
        vertical: 6,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Text(
                '${hour.toString().padLeft(2, '0')}:00',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isCurrentHour
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight:
                          isCurrentHour ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            Container(
              width: 1,
              constraints: const BoxConstraints(minHeight: 48),
              color: isCurrentHour
                  ? AppColors.primary
                  : AppColors.textSecondary.withValues(alpha: 0.2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: items.isEmpty
                  ? const SizedBox(height: 48)
                  : Column(
                      children: items
                          .map((item) => TimeSlotCard(
                                item: item,
                                onTap: () => _editSchedule(context, ref, item),
                                onDelete: () => ref
                                    .read(scheduleProvider.notifier)
                                    .deleteItem(item.id),
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
