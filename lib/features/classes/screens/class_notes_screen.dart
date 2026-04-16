import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../models/class_note.dart';
import '../providers/class_provider.dart';

const _tagLabels = {
  NoteTag.lesson: '📖 Bài giảng',
  NoteTag.student: '👩‍🎓 Học sinh',
  NoteTag.reminder: '🔔 Nhắc nhở',
  NoteTag.other: '📌 Khác',
};

const _tagColors = {
  NoteTag.lesson: AppColors.accent,
  NoteTag.student: AppColors.secondary,
  NoteTag.reminder: AppColors.primary,
  NoteTag.other: AppColors.textSecondary,
};

/// Màn hình ghi chú của 1 lớp cụ thể
class ClassNotesScreen extends ConsumerWidget {
  final String classId;

  const ClassNotesScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(classRoomProvider);
    final allNotes = ref.watch(classNoteProvider);
    final classRoom = classes.where((c) => c.id == classId).firstOrNull;
    final notes = allNotes.where((n) => n.classId == classId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text('${classRoom?.emoji ?? '🏫'} ${classRoom?.name ?? 'Lớp'}'),
      ),
      body: notes.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.note_add_outlined,
              title: 'Chưa có ghi chú',
              subtitle: 'Thêm ghi chú cho lớp này nhé ✏️',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.paddingStandard),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _NoteCard(
                  note: note,
                  onEdit: () => _editNote(context, ref, note),
                  onDelete: () => _deleteNote(context, ref, note),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addNote(BuildContext context, WidgetRef ref) async {
    final result = await _showNoteDialog(context);
    if (result != null) {
      await ref.read(classNoteProvider.notifier).add(
            classId: classId,
            content: result['content']!,
            tag: result['tag'] as NoteTag,
          );
    }
  }

  Future<void> _editNote(
      BuildContext context, WidgetRef ref, ClassNote note) async {
    final result = await _showNoteDialog(context,
        content: note.content, tag: note.tag);
    if (result != null) {
      await ref.read(classNoteProvider.notifier).update(
            note.copyWith(
              content: result['content'] as String,
              tag: result['tag'] as NoteTag,
            ),
          );
    }
  }

  Future<void> _deleteNote(
      BuildContext context, WidgetRef ref, ClassNote note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: const Text('Xóa ghi chú?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Xóa')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(classNoteProvider.notifier).delete(note.id);
    }
  }

  Future<Map<String, dynamic>?> _showNoteDialog(
    BuildContext context, {
    String content = '',
    NoteTag tag = NoteTag.other,
  }) {
    final contentController = TextEditingController(text: content);
    final formKey = GlobalKey<FormState>();
    NoteTag selectedTag = tag;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
          title: Text(content.isEmpty ? 'Thêm ghi chú ✨' : 'Sửa ghi chú ✏️'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<NoteTag>(
                  initialValue: selectedTag,
                  decoration: const InputDecoration(labelText: 'Loại ghi chú'),
                  items: NoteTag.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(_tagLabels[t]!),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedTag = v);
                  },
                ),
                const SizedBox(height: AppSpacing.gapItem),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung *',
                    hintText: 'Ghi chú cho lớp...',
                  ),
                  maxLines: 4,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Không được để trống'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context, {
                  'content': contentController.text.trim(),
                  'tag': selectedTag,
                });
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final ClassNote note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tagColor = _tagColors[note.tag] ?? AppColors.textSecondary;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.gapItem),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusButton),
                  ),
                  child: Text(
                    _tagLabels[note.tag]!,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tagColor),
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(note.date),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Sửa')),
                    const PopupMenuItem(value: 'delete', child: Text('Xóa')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
