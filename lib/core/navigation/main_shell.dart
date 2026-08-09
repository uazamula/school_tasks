import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/responsive/responsive_extension.dart';

import 'app_navigation.dart';
import 'app_navigation_controller.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppNavigationController(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _onDestinationSelected,
    );

    final navigation = AppNavigation(controller: controller);

    return Scaffold(
      body: context.useBottomNavigation
          ? navigationShell
          : Row(
              children: [
                navigation,
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
      bottomNavigationBar: context.useBottomNavigation ? navigation : null,
    );
  }
}
