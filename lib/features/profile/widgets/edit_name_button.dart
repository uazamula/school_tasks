import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';

import 'package:school_tasks/features/profile/providers/profile_controller.dart';

class EditNameButton extends ConsumerWidget {
  const EditNameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () async {
        final profile = await ref.read(profileControllerProvider.future);

        if (!context.mounted) return;

        final controller = TextEditingController(text: profile.name);

        final newName = await showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(context.l10n.editName),
              content: TextField(
                controller: controller,
                autofocus: true,
                maxLength: 30,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onSubmitted: (value) {
                  Navigator.of(context).pop(value);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: Text(context.l10n.save),
                ),
              ],
            );
          },
        );

        if (newName == null) return;

        await ref.read(profileControllerProvider.notifier).setName(newName);
      },
      child: Text(context.l10n.editName),
    );
  }
}
