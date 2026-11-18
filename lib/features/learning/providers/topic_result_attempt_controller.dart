import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';

// dart run build_runner build - у терміналі
part 'topic_result_attempt_controller.g.dart';

/// Вибір користувача; null — діє значення за замовчуванням для режиму.
@Riverpod(keepAlive: true)
class TopicResultAttemptController extends _$TopicResultAttemptController {
  @override
  Future<TopicResultAttempt?> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getTopicResultAttempt();
  }

  Future<void> setAttempt(TopicResultAttempt attempt) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setTopicResultAttempt(attempt);

    state = AsyncData(attempt);
  }
}
