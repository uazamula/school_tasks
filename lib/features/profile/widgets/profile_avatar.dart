import 'package:flutter/material.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';

import 'avatar_picker_dialog.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.avatar});

  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.editAvatar,
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => const AvatarPickerDialog(),
          );
        },
        child: CircleAvatar(
          radius: 36,
          child: Text(avatar, style: const TextStyle(fontSize: 36)),
        ),
      ),
    );
  }
}
