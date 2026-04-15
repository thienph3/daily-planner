import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

const _priorityOptions = [
  (value: 0, label: 'Thấp'),
  (value: 1, label: 'Trung bình'),
  (value: 2, label: 'Cao'),
  (value: 3, label: 'Khẩn cấp'),
];

/// Dialog tạo task mới.
/// Trả về Map với keys: title, description, priority, category khi xác nhận.
/// Trả về null khi hủy.
class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  int _priority = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop<Map<String, dynamic>>({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'priority': _priority,
      'category': _categoryController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      title: Text(
        '✨ Thêm task mới',
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
              TextFormField(
                controller: _categoryController,
                decoration: _inputDecoration('Danh mục'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
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
          child: const Text('Thêm'),
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
