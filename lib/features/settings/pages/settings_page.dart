import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        // flutter gen-l10n
        // запускаємо в терміналі
        // після кожної зміни файлів *.arb
        // з кореневої папки проєкту
        child: Text(context.l10n.settings, style: AppTextStyles.title),
      ),
    );
  }
}