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
      path: AppRoutes.learning,
      builder: (context, state) {
        final topicId = state.pathParameters['topicId']!;

        return LearningPage(topicId: topicId);
      },
    ),
  ],
);
