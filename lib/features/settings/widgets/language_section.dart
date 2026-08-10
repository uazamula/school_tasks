import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/localization/locale_controller.dart';
import 'package:school_tasks/core/preferences/preference_values.dart';

class LanguageSection extends ConsumerWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale =
        ref.watch(localeControllerProvider).value ?? const Locale('uk');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.language),
        ),
        RadioGroup<Locale>(
          groupValue: locale,
          onChanged: (value) {
            if (value != null) {
              ref.read(localeControllerProvider.notifier).setLocale(value);
            }
          },
          child: Column(
            children: [
              RadioListTile<Locale>(
                value: Locale(PreferenceValues.uk),
                title: Text(context.l10n.ukrainian),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<Locale>(
                value: Locale(PreferenceValues.en),
                title: Text(context.l10n.english),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<Locale>(
                value: Locale(PreferenceValues.tr),
                title: Text(context.l10n.turkish),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
