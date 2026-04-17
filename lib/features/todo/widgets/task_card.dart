import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/task.dart';

/// Màu pastel cho từng mức priority
const _priorityColors = [
  AppColors.accent, // 0 - Low (Mint)
  AppColors.secondary, // 1 - Medium (Peach)
  AppColors.primary, // 2 - High (Pink)
  AppColors.error, // 3 - Urgent (Red)
];

const _priorityLabels = ['Thấp', 'Trung bình', 'Cao', 'Khẩn cấp'];

/// Widget hiển thị một task đơn lẻ với swipe-to-delete.
class TaskCard extends StatelessWidget {
  final Task task;
  final bool showStrike;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.showStrike = true,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingStandard,
          vertical: AppSpacing.gapItem / 2,
        ),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingStandard),
            child: Row(
              children: [
                _KawaiiCheckbox(
                  isChecked: task.isCompleted,
                  onTap: onToggle,
                ),
                const SizedBox(width: AppSpacing.gapItem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted && showStrike
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted && showStrike
                              ? AppColors.textSecondary
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.gapItem),
                _PriorityBadge(priority: task.priority),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.sectionSpacing),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingStandard,
        vertical: AppSpacing.gapItem / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.error),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        title: const Text('Xóa task?'),
        content: Text('Bạn có chắc muốn xóa "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

/// Checkbox kawaii hình tròn với animation bounce.
class _KawaiiCheckbox extends StatefulWidget {
  final bool isChecked;
  final VoidCallback onTap;

  const _KawaiiCheckbox({required this.isChecked, required this.onTap});

  @override
  State<_KawaiiCheckbox> createState() => _KawaiiCheckboxState();
}

class _KawaiiCheckboxState extends State<_KawaiiCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _KawaiiCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked && widget.isChecked) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isChecked ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: widget.isChecked ? AppColors.primary : AppColors.textSecondary,
              width: 2,
            ),
          ),
          child: widget.isChecked
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

/// Badge hiển thị mức priority với màu pastel.
class _PriorityBadge extends StatelessWidget {
  final int priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = _priorityColors[priority.clamp(0, 3)];
    final label = _priorityLabels[priority.clamp(0, 3)];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusButton),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color == AppColors.accent ? AppColors.textPrimary : color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
