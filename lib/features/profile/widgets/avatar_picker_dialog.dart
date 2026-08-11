import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';

import 'package:school_tasks/features/profile/providers/profile_controller.dart';

class AvatarPickerDialog extends ConsumerWidget {
  const AvatarPickerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(context.l10n.editAvatar),
      content: SizedBox(
        width: 320,
        height: 400,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) async {
            await ref
                .read(profileControllerProvider.notifier)
                .setAvatar(emoji.emoji);

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}
