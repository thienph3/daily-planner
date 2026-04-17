import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../models/diary_entry.dart';
import '../providers/diary_provider.dart';

/// Danh sách mood emoji
const List<String> moodEmojis = ['😊', '😢', '😡', '😴', '🥰'];

/// Màn hình viết/sửa nhật ký
class DiaryEditorScreen extends ConsumerStatefulWidget {
  final DiaryEntry? entry;

  const DiaryEditorScreen({super.key, this.entry});

  @override
  ConsumerState<DiaryEditorScreen> createState() => _DiaryEditorScreenState();
}

class _DiaryEditorScreenState extends ConsumerState<DiaryEditorScreen> {
  late final TextEditingController _contentController;
  String _selectedMood = '';
  bool _isSaving = false;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );
    _selectedMood = widget.entry?.mood ?? '';
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(diaryProvider.notifier);
      if (_isEditing) {
        final updated = widget.entry!.copyWith(
          content: _contentController.text,
          mood: _selectedMood,
        );
        await notifier.updateEntry(updated);
      } else {
        await notifier.addEntry(
          content: _contentController.text,
          mood: _selectedMood,
        );
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu nhật ký: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = widget.entry?.date ?? DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.backgroundFor(context),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Sửa nhật ký ✏️' : 'Viết nhật ký ✨',
          style: TextStyle(
            color: AppColors.textPrimaryFor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary.withValues(alpha: 0.3),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimaryFor(context)),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ngày
            Text(
              DateFormat('EEEE, dd/MM/yyyy', 'vi').format(displayDate),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryFor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sectionSpacing),

            // Mood selector
            Text(
              'Tâm trạng hôm nay',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimaryFor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.gapItem),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: moodEmojis.map((emoji) {
                final isSelected = _selectedMood == emoji;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedMood = isSelected ? '' : emoji;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent.withValues(alpha: 0.4)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusButton,
                      ),
                      border: isSelected
                          ? Border.all(color: AppColors.accent, width: 2)
                          : null,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.sectionSpacing),

            // Content input
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 10,
              decoration: InputDecoration(
                hintText: 'Hôm nay bạn cảm thấy thế nào? ✨',
                hintStyle: TextStyle(
                  color: AppColors.textSecondaryFor(context).withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: AppColors.surfaceFor(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusInput,
                  ),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusInput,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusInput,
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(
                  AppSpacing.paddingStandard,
                ),
              ),
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textPrimaryFor(context),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
