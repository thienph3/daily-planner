import 'package:go_router/go_router.dart';

import '../core/utils/page_transition_helper.dart';
import '../features/belongings/screens/belonging_screen.dart';
import '../features/books/screens/book_screen.dart';
import '../features/classes/screens/class_list_screen.dart';
import '../features/classes/screens/class_notes_screen.dart';
import '../features/diary/models/diary_entry.dart';
import '../features/diary/screens/diary_editor_screen.dart';
import '../features/diary/screens/diary_screen.dart';
import '../features/meal_plan/screens/meal_plan_screen.dart';
import '../features/mood_tracker/screens/mood_screen.dart';
import '../features/schedule/screens/schedule_screen.dart';
import '../features/settings/screens/category_management_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/todo/screens/todo_screen.dart';
import '../shared/widgets/main_shell.dart';
import '../shared/widgets/more_menu_screen.dart';
import '../shared/widgets/weekly_dashboard.dart';

/// Cấu hình GoRouter.
/// Bottom nav: 4 tab (To-Do, Lịch trình, Bữa ăn, Thêm).
/// Nhật ký, Mood, Tiến độ, Cài đặt mở từ tab "Thêm" qua push.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => PageTransitionHelper.fadeTransition(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      // Standalone routes (push từ tab Thêm)
      GoRoute(
        path: '/diary',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
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
      GoRoute(
        path: '/mood',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
          key: state.pageKey,
          child: const MoodScreen(),
        ),
      ),
      GoRoute(
        path: '/progress',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
          key: state.pageKey,
          child: const WeeklyDashboard(),
        ),
      ),
      GoRoute(
        path: '/books',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
          key: state.pageKey,
          child: const BookScreen(),
        ),
      ),
      GoRoute(
        path: '/belongings',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
          key: state.pageKey,
          child: const BelongingScreen(),
        ),
      ),
      GoRoute(
        path: '/classes',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
          key: state.pageKey,
          child: const ClassListScreen(),
        ),
        routes: [
          GoRoute(
            path: ':classId',
            pageBuilder: (context, state) {
              final classId = state.pathParameters['classId']!;
              return PageTransitionHelper.slideUpTransition(
                key: state.pageKey,
                child: ClassNotesScreen(classId: classId),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            PageTransitionHelper.slideUpTransition(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
        routes: [
          GoRoute(
            path: 'categories',
            pageBuilder: (context, state) =>
                PageTransitionHelper.slideUpTransition(
              key: state.pageKey,
              child: const CategoryManagementScreen(),
            ),
          ),
          GoRoute(
            path: 'books',
            pageBuilder: (context, state) =>
                PageTransitionHelper.slideUpTransition(
              key: state.pageKey,
              child: const BookScreen(),
            ),
          ),
          GoRoute(
            path: 'belongings',
            pageBuilder: (context, state) =>
                PageTransitionHelper.slideUpTransition(
              key: state.pageKey,
              child: const BelongingScreen(),
            ),
          ),
        ],
      ),
      // Main shell — 4 tab bottom nav
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
                path: '/more',
                pageBuilder: (context, state) =>
                    PageTransitionHelper.fadeTransition(
                  key: state.pageKey,
                  child: const MoreMenuScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
