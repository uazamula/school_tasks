import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';
import 'package:school_tasks/features/learning/providers/effective_result_settings.dart';
import 'package:school_tasks/features/learning/providers/topic_result_attempt_controller.dart';

class TopicResultAttemptSection extends ConsumerWidget {
  const TopicResultAttemptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(effectiveTopicResultAttemptProvider);

    return ListTile(
      title: const Text('Результат на плитці'),
      trailing: DropdownButton<TopicResultAttempt>(
        value: value,
        onChanged: (next) {
          if (next == null) return;

          ref
              .read(topicResultAttemptControllerProvider.notifier)
              .setAttempt(next);
        },
        items: const [
          DropdownMenuItem(
            value: TopicResultAttempt.current,
            child: Text('Остання спроба'),
          ),
          DropdownMenuItem(
            value: TopicResultAttempt.best,
            child: Text('Найкраща спроба'),
          ),
        ],
      ),
    );
  }
}
