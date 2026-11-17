import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/theme/theme_app_theme_choice.dart';
import 'package:school_tasks/core/theme/theme_controller.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ref.watch(themeControllerProvider).value ?? ThemeMode.system;
    final themeChoice =
        ref.watch(themeControllerProvider).value ?? AppThemeChoice.system;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.appearance),
        ),
        RadioGroup<AppThemeChoice>(
          groupValue: themeChoice,
          onChanged: (value) {
            if (value != null) {
              ref.read(themeControllerProvider.notifier).setThemeChoice(value);
            }
          },
          child: Column(
            children: [
              RadioListTile<AppThemeChoice>(
                value: AppThemeChoice.system,
                title: Text(context.l10n.system),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<AppThemeChoice>(
                value: AppThemeChoice.light,
                title: Text(context.l10n.light),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<AppThemeChoice>(
                value: AppThemeChoice.dark,
                title: Text(context.l10n.dark),
                contentPadding: EdgeInsets.zero,
              ),
              // Локалізація відкладена, тому рядок поки що хардкодом.
              const RadioListTile<AppThemeChoice>(
                value: AppThemeChoice.gentle,
                title: Text('Лагідна'),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
