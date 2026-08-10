import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/theme/theme_controller.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ref.watch(themeControllerProvider).value ?? ThemeMode.system;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.appearance),
        ),
        RadioGroup<ThemeMode>(
          groupValue: themeMode,
          onChanged: (value) {
            if (value != null) {
              ref.read(themeControllerProvider.notifier).setThemeMode(value);
            }
          },
          child: Column(
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                title: Text(context.l10n.system),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                title: Text(context.l10n.light),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                title: Text(context.l10n.dark),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
