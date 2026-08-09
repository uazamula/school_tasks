import 'package:flutter/material.dart';

import 'app_navigation_controller.dart';

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({super.key, required this.controller});

  final AppNavigationController controller;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: controller.selectedIndex,
      onDestinationSelected: controller.onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
      destinations: controller.destinations
          .map(
            (destination) => NavigationRailDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: Text(destination.labelBuilder(context)),
            ),
          )
          .toList(),
    );
  }
}
