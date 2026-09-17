import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/features/settings/providers/service_sounds_controller.dart';

class ServiceSoundsSection extends ConsumerWidget {
  const ServiceSoundsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceSoundsAsync = ref.watch(serviceSoundsControllerProvider);

    return serviceSoundsAsync.when(
      loading: () => const ListTile(
        title: Text('Службові звуки'),
        trailing: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => ListTile(
        title: const Text('Службові звуки'),
        subtitle: Text('Помилка: $error'),
      ),
      data: (enabled) {
        return SwitchListTile(
          title: const Text('Службові звуки'),
          value: enabled,
          onChanged: (value) {
            ref
                .read(serviceSoundsControllerProvider.notifier)
                .setEnabled(value);
          },
        );
      },
    );
  }
}
