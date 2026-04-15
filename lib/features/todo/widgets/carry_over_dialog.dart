import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/task.dart';

/// Dialog hiển thị task chưa hoàn thành từ ngày trước.
/// Trả về danh sách [Task] được chọn khi xác nhận, null khi bỏ qua.
class CarryOverDialog extends StatefulWidget {
  final List<Task> incompleteTasks;

  const CarryOverDialog({super.key, required this.incompleteTasks});

  @override
  State<CarryOverDialog> createState() => _CarryOverDialogState();
}

class _CarryOverDialogState extends State<CarryOverDialog> {
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    // Mặc định chọn tất cả
    _selectedIds = widget.incompleteTasks.map((t) => t.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = widget.incompleteTasks.length;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      title: Text(
        '📋 Task từ hôm qua',
        style: theme.textTheme.headlineMedium,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có $count task chưa hoàn thành từ hôm qua. '
              'Bạn muốn chuyển sang hôm nay không?',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.paddingStandard),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.incompleteTasks.length,
                itemBuilder: (context, index) {
                  final task = widget.incompleteTasks[index];
                  final isSelected = _selectedIds.contains(task.id);

                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedIds.add(task.id);
                        } else {
                          _selectedIds.remove(task.id);
                        }
                      });
                    },
                    title: Text(
                      task.title,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    activeColor: AppColors.primary,
                    checkboxShape: const CircleBorder(),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Bỏ qua',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _selectedIds.isEmpty
              ? null
              : () {
                  final selected = widget.incompleteTasks
                      .where((t) => _selectedIds.contains(t.id))
                      .toList();
                  Navigator.of(context).pop<List<Task>>(selected);
                },
          child: const Text('Chuyển sang hôm nay'),
        ),
      ],
    );
  }
}
