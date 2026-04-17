import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../models/belonging.dart';
import '../providers/belonging_provider.dart';

const _statusLabels = {
  BelongingStatus.unused: 'Chưa dùng',
  BelongingStatus.inUse: 'Đang dùng',
  BelongingStatus.used: 'Đã dùng',
};

const _statusColors = {
  BelongingStatus.unused: AppColors.textSecondary,
  BelongingStatus.inUse: AppColors.accent,
  BelongingStatus.used: AppColors.success,
};

const _statusEmojis = {
  BelongingStatus.unused: '📦',
  BelongingStatus.inUse: '✋',
  BelongingStatus.used: '✅',
};

/// Màn hình quản lý đồ dùng/vật dụng
class BelongingScreen extends ConsumerWidget {
  const BelongingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(belongingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎒 Đồ dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      body: items.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.inventory_2_outlined,
              title: 'Chưa có đồ dùng nào',
              subtitle: 'Thêm vật dụng để quản lý nhé 🎒',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.paddingStandard),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _BelongingCard(
                  item: item,
                  onEdit: () => _editItem(context, ref, item),
                  onDelete: () => _deleteItem(context, ref, item),
                  onStatusChange: (status) => ref
                      .read(belongingProvider.notifier)
                      .update(item.copyWith(status: status)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addItem(BuildContext context, WidgetRef ref) async {
    final result = await _showItemDialog(context);
    if (result != null) {
      await ref.read(belongingProvider.notifier).add(
            name: result['name']!,
            status: result['status'] as BelongingStatus,
            location: result['location'] ?? '',
          );
    }
  }

  Future<void> _editItem(
      BuildContext context, WidgetRef ref, Belonging item) async {
    final result = await _showItemDialog(context,
        name: item.name, status: item.status, location: item.location);
    if (result != null) {
      await ref.read(belongingProvider.notifier).update(item.copyWith(
            name: result['name'] as String,
            status: result['status'] as BelongingStatus,
            location: result['location'] as String,
          ));
    }
  }

  Future<void> _deleteItem(
      BuildContext context, WidgetRef ref, Belonging item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: const Text('Xóa đồ dùng?'),
        content: Text('Bạn có chắc muốn xóa "${item.name}"?'),
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
      await ref.read(belongingProvider.notifier).delete(item.id);
    }
  }

  Future<Map<String, dynamic>?> _showItemDialog(
    BuildContext context, {
    String name = '',
    BelongingStatus status = BelongingStatus.unused,
    String location = '',
  }) {
    final nameController = TextEditingController(text: name);
    final locationController = TextEditingController(text: location);
    final formKey = GlobalKey<FormState>();
    BelongingStatus selectedStatus = status;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
          title: Text(
              name.isEmpty ? 'Thêm đồ dùng ✨' : 'Sửa đồ dùng ✏️'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên đồ dùng *'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Không được để trống'
                      : null,
                ),
                const SizedBox(height: AppSpacing.gapItem),
                DropdownButtonFormField<BelongingStatus>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Trạng thái'),
                  items: BelongingStatus.values
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                                '${_statusEmojis[s]} ${_statusLabels[s]}'),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setDialogState(() => selectedStatus = v);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.gapItem),
                TextFormField(
                  controller: locationController,
                  decoration:
                      const InputDecoration(labelText: 'Đang cất ở đâu?'),
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
                  'status': selectedStatus,
                  'location': locationController.text.trim(),
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

class _BelongingCard extends StatelessWidget {
  final Belonging item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<BelongingStatus> onStatusChange;

  const _BelongingCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColors[item.status] ?? AppColors.textSecondaryFor(context);

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
                Text(_statusEmojis[item.status] ?? '📦',
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(width: AppSpacing.gapItem),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textPrimaryFor(context),
                    ),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusButton),
                  ),
                  child: Text(
                    _statusLabels[item.status] ?? '',
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (item.location.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.textSecondaryFor(context)),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      item.location,
                      style: TextStyle(
                          color: AppColors.textSecondaryFor(context), fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: BelongingStatus.values.map((s) {
                final isSelected = item.status == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(_statusLabels[s]!,
                        style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    onSelected: (_) => onStatusChange(s),
                    selectedColor: (_statusColors[s] ?? AppColors.accent)
                        .withValues(alpha: 0.3),
                    backgroundColor: AppColors.surfaceFor(context),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
