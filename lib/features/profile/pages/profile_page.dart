import 'package:flutter/material.dart';

import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/widgets/app_scaffold.dart';
import 'package:school_tasks/features/profile/widgets/profile_section.dart';
import 'package:school_tasks/features/profile/widgets/statistics_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ListView(
        children: [
          Text(
            context.l10n.profile,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),

          const ProfileSection(),

          const SizedBox(height: AppSpacing.xl),

          const StatisticsSection(),
        ],
      ),
    );
  }
}
