import 'package:flutter/material.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/features/settings/widgets/appearance_section.dart';
import 'package:school_tasks/features/settings/widgets/grade_scale_section.dart';
import 'package:school_tasks/features/settings/widgets/language_section.dart';
import 'package:school_tasks/features/settings/widgets/learning_data_section.dart';
import 'package:school_tasks/features/settings/widgets/service_sounds_section.dart';
import 'package:school_tasks/features/settings/widgets/topic_result_display_section.dart';

import '../../../core/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ListView(
        children: [
          Text(
            context.l10n.settings,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          AppearanceSection(),

          Divider(),

          ServiceSoundsSection(),

          const Divider(),

          LanguageSection(),

          Divider(),

          GradeScaleSection(),

          Divider(),

          TopicResultDisplaySection(),

          Divider(),

          LearningDataSection(),
        ],
      ),
    );
  }
}
