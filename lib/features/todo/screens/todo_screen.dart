import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/kawaii_date_picker.dart';
import '../../../shared/widgets/shimmer_widget.dart';
import '../../../shared/widgets/bounce_animation_widget.dart';
import '../models/task.dart';
import '../providers/todo_provider.dart';
import '../providers/todo_state.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/carry_over_dialog.dart';
import '../widgets/edit_task_dialog.dart';
import '../widgets/task_card.dart';

/// Màn hình chính hiển thị danh sách task theo ngày.
class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;

    if (!mounted) return;

    // Kiểm tra carry-over
    final notifier = ref.read(todoProvider.notifier);
    final incompleteTasks = await notifier.getYesterdayIncompleteTasks();
    if (incompleteTasks.isNotEmpty && mounted) {
      final selected = await showDialog<List<Task>>(
        context: context,
        barrierDismissible: false,
        builder: (_) => CarryOverDialog(incompleteTasks: incompleteTasks),
      );
      if (selected != null && selected.isNotEmpty) {
        await notifier.carryOverTasks(selected);
      }
    }
  }

  Future<void> _addTask() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );
    if (result != null) {
      await ref.read(todoProvider.notifier).addTask(
        title: result['title'] as String,
        description: result['description'] as String? ?? '',
        priority: result['priority'] as int? ?? 0,
        category: result['category'] as String? ?? '',
      );
    }
  }

  Future<void> _editTask(Task task) async {
    final updated = await showDialog<Task>(
      context: context,
      builder: (_) => EditTaskDialog(task: task),
    );
    if (updated != null) {
      await ref.read(todoProvider.notifier).updateTask(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 To-Do'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      body: Column(
        children: [
          const KawaiiDatePicker(),
          _ProgressSection(state: state),
          _FilterChips(
            current: state.filter,
            onChanged: ref.read(todoProvider.notifier).setFilter,
          ),
          Expanded(
            child: state.isLoading
                ? const ShimmerListWidget()
                : state.filteredTasks.isEmpty
                    ? _EmptyState(filter: state.filter)
                    : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.gapItem,
                      bottom: 80,
                    ),
                    itemCount: state.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = state.filteredTasks[index];
                      return BounceAnimationWidget(
                        animate: task.isCompleted,
                        child: TaskCard(
                          task: task,
                          onToggle: () => ref
                              .read(todoProvider.notifier)
                              .toggleComplete(task.id),
                          onTap: () => _editTask(task),
                          onDelete: () => ref
                              .read(todoProvider.notifier)
                              .deleteTask(task.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

/// Section hiển thị progress bar.
class _ProgressSection extends StatelessWidget {
  final TodoState state;

  const _ProgressSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingStandard,
        vertical: AppSpacing.gapItem,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ hôm nay',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${state.completedCount}/${state.totalCount}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusButton),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: 10,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chips cho trạng thái task.
class _FilterChips extends StatelessWidget {
  final FilterState current;
  final ValueChanged<FilterState> onChanged;

  const _FilterChips({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingStandard),
      child: Row(
        children: FilterState.values.map((filter) {
          final isSelected = current == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_filterLabel(filter)),
              selected: isSelected,
              onSelected: (_) => onChanged(filter),
              selectedColor: AppColors.primary.withValues(alpha: 0.3),
              backgroundColor: AppColors.surface,
              checkmarkColor: AppColors.textPrimary,
              labelStyle: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusButton),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(FilterState filter) {
    switch (filter) {
      case FilterState.all:
        return 'Tất cả';
      case FilterState.incomplete:
        return 'Chưa xong';
      case FilterState.completed:
        return 'Đã xong';
    }
  }
}

/// Empty state khi không có task.
class _EmptyState extends StatelessWidget {
  final FilterState filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    if (filter == FilterState.all) {
      return const EmptyStateWidget(
        icon: Icons.check_circle_outline,
        title: 'Chưa có việc gì',
        subtitle: 'Thêm task mới để bắt đầu ngày nhé ✨',
      );
    }

    final theme = Theme.of(context);
    final message = filter == FilterState.incomplete
        ? 'Tuyệt vời! Không còn task nào chưa xong 🎉'
        : 'Chưa có task nào hoàn thành 💪';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sectionSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🌈', style: TextStyle(fontSize: 64)),
            const SizedBox(height: AppSpacing.paddingStandard),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
