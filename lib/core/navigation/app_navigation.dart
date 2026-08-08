import 'package:flutter/material.dart';
import 'package:school_tasks/core/responsive/responsive_extension.dart';

import '../extensions/context_extension.dart';
import 'app_navigation_bar.dart';
import 'app_navigation_controller.dart';
import 'app_navigation_rail.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({
    super.key,
    required this.controller,
  });

  final AppNavigationController controller;

  @override
  Widget build(BuildContext context) {
    if (context.useBottomNavigation) {
      return AppNavigationBar(
        controller: controller,
      );
    }

    return AppNavigationRail(
      controller: controller,
    );
  }
}