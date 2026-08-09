import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/theme/theme_controller.dart';

import '../../../core/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ListView(
        children: const [
          Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          _AppearanceSection(),

          Divider(),

          _LanguageSection(),
        ],
      ),
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ref.watch(themeControllerProvider).value ?? ThemeMode.system;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Appearance'),
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
                title: Text('System'),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                title: Text('Light'),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                title: Text('Dark'),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Language',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.language),
          title: Text('Language'),
          subtitle: Text('Coming soon'),
        ),
      ],
    );
  }
}
