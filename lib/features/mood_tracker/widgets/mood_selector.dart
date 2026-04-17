import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/mood_provider.dart';
import '../utils/mood_utils.dart';

/// Widget cho phép chọn mood emoji và nhập ghi chú.
class MoodSelector extends ConsumerStatefulWidget {
  const MoodSelector({super.key});

  @override
  ConsumerState<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends ConsumerState<MoodSelector> {
  String? _selectedMood;
  final _noteController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _prefill() {
    final todayRecord = ref.read(moodProvider).todayRecord;
    if (todayRecord != null) {
      _selectedMood = todayRecord.mood;
      _noteController.text = todayRecord.note;
    }
    _initialized = true;
  }

  Future<void> _saveMood() async {
    if (_selectedMood == null) return;
    await ref.read(moodProvider.notifier).saveTodayMood(
          mood: _selectedMood!,
          note: _noteController.text.trim(),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu mood! 🎉'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch state để rebuild khi todayRecord thay đổi
    ref.watch(moodProvider);
    if (!_initialized) _prefill();

    return Card(
      elevation: 2,
      color: AppColors.secondary.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn mood của bạn 🌟',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimaryFor(context),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.gapItem),
            _buildEmojiRow(),
            const SizedBox(height: AppSpacing.gapItem),
            _buildNoteField(),
            const SizedBox(height: AppSpacing.gapItem),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moodEmojis.map((emoji) {
        final isSelected = _selectedMood == emoji;
        return GestureDetector(
          onTap: () => setState(() => _selectedMood = emoji),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              shape: BoxShape.circle,
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.3 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Opacity(
                opacity: isSelected || _selectedMood == null ? 1.0 : 0.5,
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: 'Ghi chú ngắn... ✏️',
        hintStyle: TextStyle(color: AppColors.textSecondaryFor(context)),
        filled: true,
        fillColor: AppColors.surfaceFor(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingStandard,
          vertical: AppSpacing.gapItem,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _selectedMood != null ? _saveMood : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimaryFor(context),
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusButton),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.gapItem),
      ),
      child: const Text(
        'Lưu mood 💾',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
