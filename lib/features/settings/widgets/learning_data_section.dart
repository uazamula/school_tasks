import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/providers/learning_results_controller.dart';

class LearningDataSection extends ConsumerWidget {
  const LearningDataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Дані навчання'),
      subtitle: const Text('Скинути всі результати проходження тем'),
      trailing: TextButton(
        onPressed: () => _confirmReset(context, ref),
        child: const Text('Скинути'),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Скинути результати?'),
          content: const Text(
            'Усі результати проходження тем, включно з найкращими '
            'результатами, будуть видалені назавжди.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ні'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Так, скинути'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true || !context.mounted) {
      return;
    }

    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.clearLearningData();

    ref.read(learningResultsControllerProvider.notifier).clearAll();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Результати навчання скинуто')),
    );
  }
}
