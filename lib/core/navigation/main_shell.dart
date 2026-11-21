import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/responsive/responsive_extension.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';
import 'package:school_tasks/core/ui/parent_gate_dialog.dart';

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
  Widget _buildKids(BuildContext context) {
    final isHome = navigationShell.currentIndex == _homeIndex;

    return PopScope(
      // Кнопку «назад» обробляємо самі, лише на мобільних і за прапорцем.
      canPop: kIsWeb || !AppConfig.kidsBackRequiresGate,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        // З налаштувань повертаємось на головну без перевірки.
        if (!isHome) {
          navigationShell.goBranch(_homeIndex);
          return;
        }

        // Закрити застосунок можна лише після батьківського контролю.
        final passed = await showParentGate(context);

        if (passed) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              KidsShellBar(
                isHome: isHome,
                onPressed: () async {
                  // Назад на головну без перевірки.
                  if (!isHome) {
                    navigationShell.goBranch(_homeIndex);
                    return;
                  }

                  // У налаштування лише після батьківського контролю.
                  final passed = await showParentGate(context);

                  if (passed && context.mounted) {
                    navigationShell.goBranch(_settingsIndex);
                  }
                },
              ),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kidsUi = ref.watch(kidsUiControllerProvider).value ?? false;

    if (kidsUi) {
      return _buildKids(context);
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
