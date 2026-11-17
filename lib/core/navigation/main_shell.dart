import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/responsive/responsive_extension.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';

import 'app_navigation.dart';
import 'app_navigation_controller.dart';
import 'kids_shell_bar.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Індекси гілок у app_router.dart: головна і налаштування.
  static const _homeIndex = 0;
  static const _settingsIndex = 2;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  /// Оболонка дитячого режиму: без нижньої панелі та rail,
  /// лише кнопка зліва зверху.
  Widget _buildKids() {
    final isHome = navigationShell.currentIndex == _homeIndex;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            KidsShellBar(
              isHome: isHome,
              // TODO(крок 4): перед переходом у налаштування — батьківський контроль.
              onPressed: () => navigationShell.goBranch(
                isHome ? _settingsIndex : _homeIndex,
              ),
            ),
            Expanded(child: navigationShell),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kidsUi = ref.watch(kidsUiControllerProvider).value ?? false;

    if (kidsUi) {
      return _buildKids();
    }

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
