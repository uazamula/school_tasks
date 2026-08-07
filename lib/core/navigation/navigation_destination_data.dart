import 'package:flutter/material.dart';

@immutable
class NavigationDestinationData {
  const NavigationDestinationData({
    required this.icon,
    required this.selectedIcon,
    required this.labelBuilder,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String Function(BuildContext context) labelBuilder;
}