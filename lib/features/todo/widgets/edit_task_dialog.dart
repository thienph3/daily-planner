import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../settings/providers/category_provider.dart';
import '../models/task.dart';

const _priorityOptions = [
  (value: 0, label: 'Thấp'),
  (value: 1, label: 'Trung bình'),
  (value: 2, label: 'Cao'),
  (value: 3, label: 'Khẩn cấp'),
];

/// Dialog sửa task, pre-fill thông tin hiện tại.
class EditTaskDialog extends ConsumerStatefulWidget {
  final Task task;

  const EditTaskDialog({super.key, required this.task});

  @override
  ConsumerState<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends ConsumerState<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late int _priority;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _priority = widget.task.priority;
    _selectedCategory = widget.task.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      category: _selectedCategory,
    );
    Navigator.of(context).pop<Task>(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoryProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      title: Text(
        '✏️ Sửa task',
        style: theme.textTheme.headlineMedium,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Tiêu đề *'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tiêu đề không được để trống';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.gapItem),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Mô tả'),
                maxLines: 2,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.gapItem),
              DropdownButtonFormField<int>(
                initialValue: _priority,
                decoration: _inputDecoration('Mức ưu tiên'),
                items: _priorityOptions
                    .map((opt) => DropdownMenuItem(
                          value: opt.value,
                          child: Text(opt.label),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _priority = value);
                },
              ),
              const SizedBox(height: AppSpacing.gapItem),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory.isEmpty
                    ? null
                    : _selectedCategory,
                decoration: _inputDecoration('Danh mục'),
                items: [
                  const DropdownMenuItem(
                      value: '', child: Text('Không có danh mục')),
                  ...categories.map((cat) => DropdownMenuItem(
                        value: cat.name,
                        child: Text('${cat.emoji} ${cat.name}'),
                      )),
                ],
                onChanged: (value) {
                  setState(() => _selectedCategory = value ?? '');
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Hủy',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Lưu'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingStandard,
        vertical: AppSpacing.gapItem,
      ),
    );
  }
}
