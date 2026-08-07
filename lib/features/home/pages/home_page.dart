import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: context.l10n.home,
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
