import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/profile/providers/profile_controller.dart';
import 'package:school_tasks/features/profile/widgets/profile_avatar.dart';

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ListTile(title: Text(error.toString())),
      data: (profile) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvatar(avatar: profile.avatar),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Text(
                profile.name.isEmpty
                    ? context.l10n.defaultUserName
                    : profile.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
