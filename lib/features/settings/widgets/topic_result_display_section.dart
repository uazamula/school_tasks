import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';
import 'package:school_tasks/features/learning/providers/effective_result_settings.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';

class TopicResultDisplaySection extends ConsumerWidget {
  const TopicResultDisplaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(effectiveTopicResultDisplayProvider);

    return ListTile(
      title: const Text('Відображення результату'),
      trailing: DropdownButton<TopicResultDisplay>(
        value: display,
        onChanged: (value) {
          if (value == null) return;

          ref
              .read(topicResultDisplayControllerProvider.notifier)
              .setTopicResultDisplay(value);
        },
        items: const [
          DropdownMenuItem(
            value: TopicResultDisplay.grade,
            child: Text('Лише оцінка'),
          ),
          DropdownMenuItem(
            value: TopicResultDisplay.duration,
            child: Text('Лише тривалість'),
          ),
          DropdownMenuItem(
            value: TopicResultDisplay.gradeAndDuration,
            child: Text('Оцінка + тривалість'),
          ),
        ],
      ),
    );
  }
}