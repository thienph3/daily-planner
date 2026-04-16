import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';

/// Màn hình "Thêm" hiển thị grid các tính năng phụ
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  static const _menuItems = [
    _MenuItem(emoji: '📖', label: 'Nhật ký', route: '/diary'),
    _MenuItem(emoji: '🌈', label: 'Mood', route: '/mood'),
    _MenuItem(emoji: '📊', label: 'Tiến độ tuần', route: '/progress'),
    _MenuItem(emoji: '📚', label: 'Sách', route: '/books'),
    _MenuItem(emoji: '🎒', label: 'Đồ dùng', route: '/belongings'),
    _MenuItem(emoji: '🏫', label: 'Lớp học', route: '/classes'),
    _MenuItem(emoji: '⚙️', label: 'Cài đặt', route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌸 Thêm')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.gapItem,
            crossAxisSpacing: AppSpacing.gapItem,
            childAspectRatio: 1.3,
          ),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final item = _menuItems[index];
            return _MenuCard(
              item: item,
              onTap: () => context.push(item.route),
            );
          },
        ),
      ),
    );
  }
}

class _MenuItem {
  final String emoji;
  final String label;
  final String route;

  const _MenuItem({
    required this.emoji,
    required this.label,
    required this.route,
  });
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _MenuCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              item.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
