import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';

/// Перемикач дитячого інтерфейсу в налаштуваннях.
class KidsUiSection extends ConsumerWidget {
  const KidsUiSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Перемикач можна сховати програмно.
    if (!AppConfig.kidsUiSwitchVisible) {
      return const SizedBox.shrink();
    }

    final enabled = ref.watch(kidsUiControllerProvider).value ?? false;

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Дитячий інтерфейс'),
      subtitle: const Text('Спрощений вигляд для дошкільнят'),
      value: enabled,
      onChanged: (value) {
        ref.read(kidsUiControllerProvider.notifier).setEnabled(value);
      },
    );
  }
}
