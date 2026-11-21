import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/responsive/responsive_extension.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';
import 'package:school_tasks/core/ui/parent_gate_dialog.dart';
import 'package:school_tasks/routing/settings_access_guard.dart';

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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kidsUi = ref.watch(kidsUiControllerProvider).value ?? false;
    final isHome = navigationShell.currentIndex == _homeIndex;
    final showRail = !kidsUi && !context.useBottomNavigation;
    final showBottomBar = !kidsUi && context.useBottomNavigation;

    final navigation = kidsUi
        ? null
        : AppNavigation(
            controller: AppNavigationController(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
          );

    return PopScope(
      // «Назад» обробляємо самі лише в дитячому режимі на мобільних.
      canPop: !kidsUi || kIsWeb || !AppConfig.kidsBackRequiresGate,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        if (!isHome) {
          navigationShell.goBranch(_homeIndex);
          return;
        }

        if (await showParentGate(context)) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        bottomNavigationBar: showBottomBar ? navigation : null,
        // Структура дерева однакова в обох режимах, щоб navigationShell
        // не переїжджав між батьками (інакше помилка GlobalKey).
        body: SafeArea(
          top: kidsUi,
          bottom: kidsUi,
          left: kidsUi,
          right: kidsUi,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Вільна смужка зверху лише в дитячому режимі. Дерево віджетів
              // однакове в обох режимах, змінюється тільки значення відступу.
              Row(
                children: [
                  showRail ? navigation! : const SizedBox.shrink(),
                  showRail
                      ? const VerticalDivider(width: 1)
                      : const SizedBox.shrink(),
                  Expanded(child: navigationShell),
                ],
              ),
              if (kidsUi)
                Positioned(
                  top: 0,
                  left: 0,
                  child: KidsShellBar(
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
                        settingsAccessGuard.unlocked = true;
                        navigationShell.goBranch(_settingsIndex);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
