import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/navigation/kids_shell_bar.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';
import 'package:school_tasks/features/settings/widgets/appearance_section.dart';
import 'package:school_tasks/features/settings/widgets/grade_scale_section.dart';
import 'package:school_tasks/features/settings/widgets/kids_ui_section.dart';
import 'package:school_tasks/features/settings/widgets/language_section.dart';
import 'package:school_tasks/features/settings/widgets/learning_data_section.dart';
import 'package:school_tasks/features/settings/widgets/reset_settings_section.dart';
import 'package:school_tasks/features/settings/widgets/service_sounds_section.dart';
import 'package:school_tasks/features/settings/widgets/topic_result_attempt_section.dart';
import 'package:school_tasks/features/settings/widgets/topic_result_display_section.dart';

import '../../../core/widgets/app_scaffold.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kidsUi = ref.watch(kidsUiControllerProvider).value ?? false;

    return AppScaffold(
      child: ListView(
        children: [
          if (kidsUi) const SizedBox(height: KidsShellBar.height),
          Text(
            // ... решта без змін
            context.l10n.settings,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          AppearanceSection(),

          Divider(),

          KidsUiSection(),

          Divider(),

          ServiceSoundsSection(),

          const Divider(),

          LanguageSection(),

          Divider(),

          GradeScaleSection(),

          Divider(),

          TopicResultDisplaySection(),

          Divider(),

          TopicResultAttemptSection(),

          Divider(),

          LearningDataSection(),

          Divider(),

          ResetSettingsSection(),
        ],
      ),
    );
  }
}
