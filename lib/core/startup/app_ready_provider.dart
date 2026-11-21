import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/localization/locale_controller.dart';
import 'package:school_tasks/core/startup/load_topic_results.dart';
import 'package:school_tasks/core/theme/theme_controller.dart';
import 'package:school_tasks/core/ui/kids_ui_controller.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';
import 'package:school_tasks/features/learning/providers/learning_tree_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_attempt_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';

/// Готовність налаштувань, які впливають на вигляд при старті.
/// Помилка будь-якого з них не блокує запуск: діють значення за замовчуванням.
final appReadyProvider = FutureProvider<void>((ref) async {
  Future<void> safe(Future<Object?> future) async {
    try {
      await future;
    } catch (_) {
      // Ігноруємо: застосунок стартує зі значеннями за замовчуванням.
    }
  }

  await Future.wait([
    safe(ref.watch(themeControllerProvider.future)),
    safe(ref.watch(localeControllerProvider.future)),
    safe(ref.watch(kidsUiControllerProvider.future)),
    safe(ref.watch(gradeScaleControllerProvider.future)),
    safe(ref.watch(topicResultAttemptControllerProvider.future)),
    safe(ref.watch(topicResultDisplayControllerProvider.future)),
    safe(ref.watch(learningTreeControllerProvider.future)),
  ]);
  // Результати тем: плитки не мають мигати порожнім станом.
  await safe(loadTopicResults(ref));
});
