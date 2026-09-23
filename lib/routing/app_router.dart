import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/features/profile/pages/profile_page.dart';

import '../core/navigation/main_shell.dart';
import '../features/home/pages/home_page.dart';
import '../features/learning/presentation/pages/learning_page.dart';
import '../features/settings/pages/settings_page.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final homeBranchNavigatorKey = GlobalKey<NavigatorState>();
final settingsBranchNavigatorKey = GlobalKey<NavigatorState>();
final profileBranchNavigatorKey = GlobalKey<NavigatorState>();

final LearningExitGuard _learningExitGuard = LearningExitGuard();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: homeBranchNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: profileBranchNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: settingsBranchNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/learning/:topicId',
      parentNavigatorKey: rootNavigatorKey,
      onExit: (context, state) async {
        if (_learningExitGuard.allowExit) {
          _learningExitGuard.allowExit = false;
          return true;
        }

        final shouldExit = await _confirmLearningExit(context);

        if (!shouldExit) {
          return false;
        }

        // Не дозволяємо поточному Back завершити маршрут.
        // Замість цього нижче виконаємо такий самий перехід,
        // як при нормальному завершенні теми.
        _learningExitGuard.allowExit = true;

        Future.microtask(() {
          if (!context.mounted) {
            return;
          }

          Router.neglect(context, () => context.go(AppRoutes.home));
        });

        return false;
      },
      pageBuilder: (context, state) {
        final topicId = state.pathParameters['topicId']!;

        return NoTransitionPage(
          key: state.pageKey,
          child: LearningPage(topicId: topicId, exitGuard: _learningExitGuard),
        );
      },
    ),
  ],
);

Future<bool> _confirmLearningExit(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Вийти з проходження?'),
        content: const Text('Поточний результат проходження буде втрачено.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Залишитися'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Вийти'),
          ),
        ],
      );
    },
  );

  return shouldExit == true;
}

class LearningExitGuard {
  bool allowExit = false;
}
