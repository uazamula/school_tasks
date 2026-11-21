import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/providers/learning_results_controller.dart';

/// Завантажує збережені результати тем у контролер результатів.
Future<void> loadTopicResults(Ref ref) async {
  final preferences = await ref.read(appPreferencesProvider.future);
  final controller = ref.read(learningResultsControllerProvider.notifier);

  for (final topic in LearningContent.topics.values) {
    final result = preferences.getTopicResult(topic.id);

    if (result == null) continue;

    // Вид результату змінився (оцінка <-> серія): старий результат
    // непорівнянний, тому скидаємо його.
    if (result.kind != topic.resultKind) {
      await preferences.clearTopicResult(topic.id);
      continue;
    }

    controller.setResult(topic.id, result);
  }
}
