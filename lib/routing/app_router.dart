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

        final guard = _learningExitGuard;

        if (guard.hasSavableProgress?.call() ?? false) {
          guard.onExitDialogOpened?.call();

          final shouldFinish = await _confirmLearningFinish(
            context,
            guard.exitSummary?.call(),
          );

          if (!shouldFinish) {
            guard.onExitDialogClosed?.call();
            return false;
          }

          // Сторінка сама збереже результат і перейде на головну.
          guard.finishOnQuit?.call();
          return false;
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

Future<bool> _confirmLearningFinish(
    BuildContext context,
    String? summary,
    ) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Завершити й зберегти?'),
        content: Text(
          [?summary, 'Результат буде збережено.'].join('\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Продовжити'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Завершити'),
          ),
        ],
      );
    },
  );

  return result == true;
}

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

  /// Нижче поля реєструє LearningPage, поки вона відкрита.
  bool Function()? hasSavableProgress;
  String? Function()? exitSummary;
  VoidCallback? onExitDialogOpened;
  VoidCallback? onExitDialogClosed;
  VoidCallback? finishOnQuit;

  void detach() {
    hasSavableProgress = null;
    exitSummary = null;
    onExitDialogOpened = null;
    onExitDialogClosed = null;
    finishOnQuit = null;
  }
}