import 'package:flutter/material.dart';

import 'app_navigation_controller.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key, required this.controller});

  final AppNavigationController controller;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: controller.selectedIndex,
      onDestinationSelected: controller.onDestinationSelected,
      destinations: controller.destinations
          .map(
            (destination) => NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.labelBuilder(context),
            ),
          )
          .toList(),
    );
  }
}
