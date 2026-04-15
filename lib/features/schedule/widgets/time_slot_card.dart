import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/schedule_item.dart';

/// Widget hiển thị một hoạt động trên timeline
class TimeSlotCard extends StatelessWidget {
  final ScheduleItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TimeSlotCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = Color(item.color);
    final timeFormat = DateFormat('HH:mm');

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteConfirm(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: itemColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: itemColor, width: 4),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C4033),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${timeFormat.format(item.startTime)} - ${timeFormat.format(item.endTime)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF8B7D6B),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xóa hoạt động?'),
        content: Text('Bạn có chắc muốn xóa "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }
}
