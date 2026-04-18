import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';

/// Màn hình cài đặt
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Cài đặt')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.paddingStandard),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: Text(isDark ? 'Đang bật' : 'Đang tắt'),
              value: isDark,
              onChanged: (_) =>
                  ref.read(themeProvider.notifier).toggleTheme(),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            ),
          ),
          const SizedBox(height: AppSpacing.gapItem),
          Card(
            child: ListTile(
              leading: const Text('📂', style: TextStyle(fontSize: 24)),
              title: const Text('Quản lý danh mục'),
              subtitle: const Text('Danh mục cho task'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/categories'),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          Center(
            child: Text(
              'Kawaii Daily Planner v0.0.4 🌸',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
