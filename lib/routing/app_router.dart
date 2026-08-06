import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/pages/home_page.dart';
import '../features/home/pages/settings_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);