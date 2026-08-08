import 'package:flutter/material.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/navigation/navigation_destination_data.dart';

// тут додаються кнопки на панель навігації

abstract final class AppNavigationDestinations {
  static final List<NavigationDestinationData> items = [
    NavigationDestinationData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      labelBuilder: (context) => context.l10n.home,
    ),
    NavigationDestinationData(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      labelBuilder: (context) => context.l10n.settings,
    ),
  ];
}