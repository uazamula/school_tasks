import 'package:flutter/foundation.dart';
import 'package:school_tasks/core/navigation/navigation_destinations.dart';

import 'navigation_destination_data.dart';

class AppNavigationController {
  const AppNavigationController({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  List<NavigationDestinationData> get destinations =>
      AppNavigationDestinations.items;

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
}