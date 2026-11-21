import 'package:school_tasks/core/theme/theme_app_theme_choice.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_attempt.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';

/// Набір значень за замовчуванням для режиму інтерфейсу.
/// Діє, поки користувач не обрав своє значення в налаштуваннях.
class UiProfile {
  const UiProfile({
    required this.themeChoice,
    required this.gradeScale,
    required this.resultAttempt,
    required this.resultDisplay,
    required this.serviceSounds,
  });

  final AppThemeChoice themeChoice;
  final GradeScale gradeScale;
  final TopicResultAttempt resultAttempt;
  final TopicResultDisplay resultDisplay;
  final bool serviceSounds;
}
