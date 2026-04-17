import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/shimmer_widget.dart';
import '../models/diary_entry.dart';
import '../providers/diary_provider.dart';
import '../widgets/diary_card.dart';

/// Màn hình chính hiển thị danh sách nhật ký
class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({super.key});

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(diaryProvider.notifier).loadEntries();
    });
  }

  Future<void> _confirmDelete(DiaryEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        title: Text(
          'Xóa nhật ký? 🗑️',
          style: TextStyle(color: AppColors.textPrimaryFor(context)),
        ),
        content: Text(
          'Bạn có chắc muốn xóa bài nhật ký này không?',
          style: TextStyle(color: AppColors.textSecondaryFor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(diaryProvider.notifier).deleteEntry(entry.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryProvider);
    final entries = state.sortedEntries;

    return Scaffold(
      backgroundColor: AppColors.backgroundFor(context),
      appBar: AppBar(
        title: Text(
          'Nhật ký 📖',
          style: TextStyle(
            color: AppColors.textPrimaryFor(context),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColors.primary.withValues(alpha: 0.3),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      body: state.isLoading
          ? const ShimmerListWidget()
          : entries.isEmpty
              ? _buildEmptyState()
              : _buildList(entries),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/diary/editor'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      icon: Icons.book_outlined,
      title: 'Chưa có nhật ký',
      subtitle: 'Viết vài dòng về ngày hôm nay nhé 📝',
    );
  }

  Widget _buildList(List<DiaryEntry> entries) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.paddingStandard),
      itemCount: entries.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.gapItem),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return DiaryCard(
          entry: entry,
          onTap: () => context.push('/diary/editor', extra: entry),
          onDelete: () => _confirmDelete(entry),
        );
      },
    );
  }
}
