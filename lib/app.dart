import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'routes/app_router.dart';

/// Widget gốc của ứng dụng Kawaii Daily Planner.
/// Watch themeProvider để cập nhật theme mode động.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Kawaii Daily Planner',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
