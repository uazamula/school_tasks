import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';
import 'package:school_tasks/features/learning/providers/topic_result_attempt_controller.dart';

class TopicResultAttemptSection extends ConsumerWidget {
  const TopicResultAttemptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kidsUi = ref.watch(kidsUiControllerProvider).value ?? false;
    final chosen = ref.watch(topicResultAttemptControllerProvider).value;

    // Поки користувач не обирав, діє значення за замовчуванням для режиму.
    final value =
        chosen ??
        (kidsUi
            ? AppConfig.kidsResultAttemptDefault
            : AppConfig.resultAttemptDefault);

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
