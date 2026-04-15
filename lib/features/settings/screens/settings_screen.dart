import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/theme_provider.dart';

/// Màn hình cài đặt chứa toggle theme light/dark.
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
        ],
      ),
    );
  }
}
