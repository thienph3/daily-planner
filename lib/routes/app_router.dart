import 'package:go_router/go_router.dart';

import '../core/utils/page_transition_helper.dart';
import '../features/diary/models/diary_entry.dart';
import '../features/diary/screens/diary_editor_screen.dart';
import '../features/diary/screens/diary_screen.dart';
import '../features/meal_plan/screens/meal_plan_screen.dart';
import '../features/mood_tracker/screens/mood_screen.dart';
import '../features/schedule/screens/schedule_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/todo/screens/todo_screen.dart';
import '../shared/widgets/main_shell.dart';
import '../shared/widgets/weekly_dashboard.dart';

/// Cấu hình GoRouter với splash route, tab routes, và sub-routes.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash screen — initial route
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => PageTransitionHelper.fadeTransition(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      // Settings — sub-route with slide up transition
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
      // Main shell with tab navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/todo',
                pageBuilder: (context, state) =>
                    PageTransitionHelper.fadeTransition(
                  key: state.pageKey,
                  child: const TodoScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/schedule',
                pageBuilder: (context, state) =>
                    PageTransitionHelper.fadeTransition(
                  key: state.pageKey,
                  child: const ScheduleScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/meal-plan',
                pageBuilder: (context, state) =>
                    PageTransitionHelper.fadeTransition(
                  key: state.pageKey,
                  child: const MealPlanScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/diary',
                pageBuilder: (context, state) =>
                    PageTransitionHelper.fadeTransition(
                  key: state.pageKey,
                  child: const DiaryScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'editor',
                    pageBuilder: (context, state) {
                      final entry = state.extra as DiaryEntry?;
                      return PageTransitionHelper.slideUpTransition(
                        key: state.pageKey,
                        child: DiaryEditorScreen(entry: entry),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mood',
                pageBuilder: (context, state) =>
                    PageTransitionHelper.fadeTransition(
                  key: state.pageKey,
                  child: const MoodScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                pageBuilder: (context, state) =>
                    PageTransitionHelper.fadeTransition(
                  key: state.pageKey,
                  child: const WeeklyDashboard(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
