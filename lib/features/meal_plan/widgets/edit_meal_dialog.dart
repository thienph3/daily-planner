import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

/// Dialog cho phép người dùng nhập hoặc sửa nội dung một bữa ăn.
class EditMealDialog extends StatefulWidget {
  final String title;
  final String emoji;
  final String initialContent;
  final bool requireNonEmpty;

  const EditMealDialog({
    super.key,
    required this.title,
    required this.emoji,
    this.initialContent = '',
    this.requireNonEmpty = false,
  });

  /// Hiển thị dialog và trả về nội dung khi xác nhận, null khi hủy.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String emoji,
    String initialContent = '',
    bool requireNonEmpty = false,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => EditMealDialog(
        title: title,
        emoji: emoji,
        initialContent: initialContent,
        requireNonEmpty: requireNonEmpty,
      ),
    );
  }

  @override
  State<EditMealDialog> createState() => _EditMealDialogState();
}

class _EditMealDialogState extends State<EditMealDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      title: Row(
        children: [
          Text(widget.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 8),
          Text(widget.title, style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          maxLines: 4,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nhập nội dung ${widget.title.toLowerCase()}...',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: widget.requireNonEmpty
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nội dung không được để trống';
                  }
                  return null;
                }
              : null,
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
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusButton),
            ),
          ),
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
