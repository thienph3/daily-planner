import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../models/class_room.dart';
import '../providers/class_provider.dart';

/// Màn hình danh sách lớp học
class ClassListScreen extends ConsumerWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(classRoomProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('🏫 Lớp học')),
      body: classes.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.school_outlined,
              title: 'Chưa có lớp nào',
              subtitle: 'Thêm lớp học để bắt đầu ghi chú 📝',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.paddingStandard),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final cls = classes[index];
                final noteCount = ref
                    .watch(classNoteProvider)
                    .where((n) => n.classId == cls.id)
                    .length;
                return _ClassCard(
                  classRoom: cls,
                  noteCount: noteCount,
                  onTap: () => context.push('/classes/${cls.id}'),
                  onEdit: () => _editClass(context, ref, cls),
                  onDelete: () => _deleteClass(context, ref, cls),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addClass(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addClass(BuildContext context, WidgetRef ref) async {
    final result = await _showClassDialog(context);
    if (result != null) {
      await ref.read(classRoomProvider.notifier).add(
            name: result['name']!,
            emoji: result['emoji']!,
          );
    }
  }

  Future<void> _editClass(
      BuildContext context, WidgetRef ref, ClassRoom cls) async {
    final result =
        await _showClassDialog(context, name: cls.name, emoji: cls.emoji);
    if (result != null) {
      await ref.read(classRoomProvider.notifier).update(
            cls.copyWith(name: result['name'], emoji: result['emoji']),
          );
    }
  }

  Future<void> _deleteClass(
      BuildContext context, WidgetRef ref, ClassRoom cls) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: const Text('Xóa lớp?'),
        content: Text(
            'Xóa "${cls.name}" sẽ xóa luôn tất cả ghi chú của lớp này.'),
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
      await ref.read(classRoomProvider.notifier).delete(cls.id);
    }
  }

  Future<Map<String, String>?> _showClassDialog(
    BuildContext context, {
    String name = '',
    String emoji = '🏫',
  }) {
    final nameController = TextEditingController(text: name);
    final emojiController = TextEditingController(text: emoji);
    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: Text(name.isEmpty ? 'Thêm lớp ✨' : 'Sửa lớp ✏️'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emojiController,
                decoration: const InputDecoration(labelText: 'Emoji'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: AppSpacing.gapItem),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên lớp *'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Không được để trống' : null,
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
                'name': nameController.text.trim(),
                'emoji': emojiController.text.trim().isEmpty
                    ? '🏫'
                    : emojiController.text.trim(),
              });
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassRoom classRoom;
  final int noteCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClassCard({
    required this.classRoom,
    required this.noteCount,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.gapItem),
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
              Text(classRoom.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: AppSpacing.gapItem),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classRoom.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$noteCount ghi chú',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
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
        ),
      ),
    );
  }
}
